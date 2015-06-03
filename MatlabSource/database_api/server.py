'''
CSE 145 EEG Server

@author Alex Rosengarten
@date May 19 2015

Function: This listens for a remote procedure call from a seizure classifier.
If the classifier detects a seizure, this server will save up to the last hour
of EEG/EKG data in to a SQLite database.

'''


#imports
import argparse # new in Python 2.7
import db_api as db
import socket
from Queue import Queue
import sys
import json
from jsonrpc import JSONRPCResponseManager, dispatcher


class EEGServer:

    def __init__(self, host='localhost', port=8888):
        # Parameters
        self.MAX_BYTES = 2**15

        self.db = db.DataStorage()

        self.entry = dict()
        self.subj_name = ''
        self.group_name = ''

        # add class methods to rpc disbatcher
        dispatcher['foo']             = self.foo
        dispatcher['storeData']       = self.storeData
        dispatcher['printData']       = self.printData
        dispatcher['writeDataToFile'] = self.writeDataToFile
        dispatcher['readMetadata']    = self.readMetadata
        dispatcher['readDataSegment'] = self.readDataSegment
        dispatcher['flush']           = self.flush

        #
        self.buff = Queue()

        # Start + Run Server
        self.createSocket(host, port) # HOST='137.110.32.112', PORT=8888
        self.processIncomingConnections()



    def createSocket(self, HOST, PORT):
        self.s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        print 'Socket created. ' + HOST + ':' + str(PORT)

        try:
            self.s.bind((HOST, PORT))
        except self.s.err as msg:
            print 'Bind failed. Error Code: ' + str(msg[0]) + ' Message ' + msg[1]
            sys.exit()

        print 'Socket bind complete'

        self.s.listen(5) # starts listening to incoming connections
        print 'Socket now listening'

    def processIncomingConnections(self):
        try:
            while True:
                conn, addr = self.s.accept() # grab the next person from the queue
                # conn is another socket, addr is the address of person connected to sever
                print "Connected with " + addr[0] + " : " + str(addr[1])

                while True:

                    # while True:
                    incoming_msg = conn.recv(self.MAX_BYTES)
                    # if not incoming_msg: break

                    print incoming_msg
                    response = JSONRPCResponseManager.handle(incoming_msg, dispatcher)
                    conn.sendall(response.json)
                    conn.send('\n') # Terminating symbol

        except KeyboardInterrupt:
            print("Keyboard Interrupt - Shutting down cleanly...")
            self.s.close()
        # except:
        #     e = sys.exc_info()[0]
        #     e1 = sys.exc_info()[2]
        #     print("Exception : {} : {}".format(e, e1))
        #     print("Shutting down cleanly...")
        #     self.s.close()

    def foo(self, name):
        return "Hello, {}".format(name)

    def readMetadata(self, subj_name='test_subj', group_name='', num_channels=8,
        channel_labels='', sample_rate=250, reference=1):
        self.subj_name  = subj_name
        self.group_name = group_name
        self.entry['num_channels']   = num_channels
        self.entry['channel_labels'] = channel_labels
        self.entry['sample_rate']    = sample_rate
        self.entry['reference']      = reference

        # self.db.storeLastHourOfData(subj_name, group_name, entry)

        return "Success: Read Metadata."

    def readDataSegment(self, data):
        self.buff.put(data)
        return "Success: Added data segment to buffer."

    def flush(self):
        # Store data
        self.db.storeLastHourOfData(self.subj_name, self.group_name, self.entry)

        # Reset class buffers
        self.entry      = dict()
        self.subj_name  = ''
        self.group_name = ''

        return "Success: Stored buffered data to database."


    def storeData(self, subj_name='test_subj', group_name='', num_channels=8,
        channel_labels='', sample_rate=250, reference=1,  data=[1,2,3]):
        entry = dict()
        entry['num_channels']   = num_channels
        entry['channel_labels'] = channel_labels
        entry['sample_rate']    = sample_rate
        entry['reference']      = reference
        entry['data']           = data

        self.db.storeLastHourOfData(subj_name, group_name, entry)

        return "Success: Added {} to databse in group {}.".format(subj_name, group_name)

    def printData(self):
        self.db.printAllData()
        return "Success: Data printed"

    def writeDataToFile(self, filename):
        data = self.db.sendAllData()
        try:
            f = open(filename)
        except IOError:
            return "Failure: file " + filename + " not found."
        except:
            e = sys.exc_info()[0]
            return "Failure: exception found: " + e

        f.truncate()

        for d in data:
            f.write(d)

        f.close()
        return "Success: wrote all data to file " + filename + "."

    def sendLastData(self):
        ret = self.db.sendLastHourOfData()
        return ret

    # def storeData2(self, subj_name):
    #     # subj_name = 'Emon Shakoor'
    #     group_name = 'test'
    #     entry = dict()
    #     entry['num_channels']   = 8
    #     entry['channel_labels'] = "F1 F2 F3 F4 F5 F6 F7 F8"
    #     entry['sample_rate']    = 250
    #     entry['reference']      = 8
    #     entry['data']           = "1,2,3,4,5"

    #     self.db.storeLastHourOfData(subj_name, group_name, entry)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Server Interface")
    parser.add_argument('-p', '--port', default=8888, type=int, help='Set port, default is 8888')
    parser.add_argument('-r', '--remote', action='store_true', default='localhost', help='Set remote host, default is localhost')

    args = parser.parse_args()

    eegServer = EEGServer(args.remote, args.port)


'''

Example json remote procedure calls

{ "method": "foo", "params": ["echome!"], "jsonrpc": "2.0", "id": 0}

{ "method": "storeData", "params": ["Emon Shakoor"], "jsonrpc": "2.0", "id": 0 }

{ "method": "printData", "params": [], "jsonrpc": "2.0", "id": 0}


matlab calls:

json_rpc('localhost', 8888, 'foo', '['echome!']', 0)


{ "jsonrpc": "2.0",    "id": 1, "method": "printData", "params": {} }

{
    "jsonrpc": "2.0",
    "id": 0,
    "method": "printData",
    "params": {
    }
}


{   "jsonrpc": "2.0",   "id": 2,    "method": "storeData",  "params": {         "num_channels": 8,      "channel_labels": "F1, F2, F3, F4, F5, F6, F7, F8",         "sample_rate": 250,         "reference": 8,         "data": [1,3,5,7,9,11,13,15,17,19,21,23,25,27,29,31,33,35,37,39,41,43,45,47,49,51,53,55,57,59,61,63,65,67,69,71,73,75,77,79,81,83,85,87,89,91,93,95,97,99,101,103,105,107,109,111,113,115,117,119,121,123,125,127,129,131,133,135,137,139,141,143,145,147,149,151,153,155,157,159,161,163,165,167,169,171,173,175,177,179,181,183,185,187,189,191,193,195,197,199,201,203,205,207,209,211,213,215,217,219,221,223,225,227,229,231,233,235,237,239,241,243,245,247,249,251,253,255,257,259,261,263,265,267,269,271,273,275,277,279,281,283,285,287,289,291,293,295,297,299,301,303,305,307,309,311,313,315,317,319,321,323,325,327,329,331,333,335,337,339,341,343,345,347,349,351,353,355,357,359,361,363,365,367,369,371,373,375,377,379,381,383,385,387,389,391,393,395,397,399,401,403,405,407,409,411,413,415,417,419,421,423,425,427,429,431,433,435,437,439,441,443,445,447,449,451,453,455,457,459,461,463,465,467,469,471,473,475,477,479,481,483,485,487,489,491,493,495,497,499,501,503,505,507,509,511,513,515,517,519,521,523,525,527,529,531,533,535,537,539,541,543,545,547,549,551,553,555,557,559,561,563,565,567,569,571,573,575,577,579,581,583,585,587,589,591,593,595,597,599,601,603,605,607,609,611,613,615,617,619,621,623,625,627,629,631,633,635,637,639,641,643,645,647,649,651,653,655,657,659,661,663,665,667,669,671,673,675,677,679,681,683,685,687,689,691,693,695,697,699,701,703,705,707,709,711,713,715,717,719,721,723,725,727,729,731,733,735,737,739,741,743,745,747,749,751,753,755,757,759,761,763,765,767,769,771,773,775,777,779,781,783,785,787,789,791,793,795,797,799,801,803,805,807,809,811,813,815,817,819,821,823,825,827,829,831,833,835,837,839,841,843,845,847,849,851,853,855,857,859,861,863,865,867,869,871,873,875,877,879,881,883,885,887,889,891,893,895,897,899,901,903,905,907,909,911,913,915,917,919,921,923,925,927,929,931,933,935,937,939,941,943,945,947,949,951,953,955,957,959,961,963,965,967,969,971,973,975,977,979,981,983,985,987,989,991,993,995,997,999],         "subj_name": "Emon Shakoor",        "group_name": "group 2"     } }


'''





