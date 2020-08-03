#!/usr/bin/python
# -*- coding: utf-8 -*-
'''
CSE 145 EEG Data Storage API

@author: Alex Rosengarten
@date: May 18 2015

Table Fields:
    subj_name
    group
    date
    id
    data {
        num_channels
        channel_locations
        sample_rate
        reference
        data
    }


'''

import sqlite3 as lite
import datetime as dt
import time
import json
import sys


class DataStorage:

    #initOrLoadDatabase
    def __init__(self, dbname='eeg_data', tablename='EEG_data'):
        #set target database
        if(('.db' in dbname) == False):
            self.db_name = dbname + '.db'
        else:
            self.db_name = dbname

        self.conn = None
        self.table_name = tablename

        self.conn = lite.connect(self.db_name)

        with self.conn:
            self.cur = self.conn.cursor()

            self.cur.executescript("""
                DROP TABLE IF EXISTS EEG_data;
                CREATE TABLE EEG_data(
                  id INTEGER PRIMARY KEY,
                  subj_name VARCHAR(20),
                  group_label VARCHAR(20),
                  date DATETIME,
                  data BLOB(1000000000)
                ); """)

            # self.bootstrapData()
            # Print database version
            self.cur.execute('SELECT SQLITE_VERSION()')
            vers = self.cur.fetchone()
            print "SQLite version: %s" % vers

    def cleanDatabase(self):
        with self.conn:
            self.cur.execute("DELETE FROM {}".format(self.table_name))

    def bootstrapData(self):

        sample_data = {
            'num_channels': 8,
            'channel_locations': ["Fp1", "Fp2", "F3", "F4", "C3", "Cz", "C4", "ref"],
            'sample_rate': 250,
            'reference': 8,
            'data': ["1,2,3,4,5,6,7,8"]
        }

        initdata = (
            ('AlexR','Softies', dt.datetime.today(), json.dumps(sample_data)),
            ('AlexM','Softies', dt.datetime.today(), json.dumps(sample_data)),
            ('MikeW','Hardons', dt.datetime.today(), json.dumps(sample_data)),
            ('MikeL','Hardons', dt.datetime.today(), json.dumps(sample_data)),
            ('RaulP','Hardons', dt.datetime.today(), json.dumps(sample_data))
        )
        with self.conn:
            self.cur.executemany("INSERT INTO {}(subj_name, group_label, date, data) VALUES(?, ?, ?, ?)".format(self.table_name), initdata)
                #sendAllData


    def storeLastHourOfData(self, subj_name, group_label, data):
        with self.conn:
            fields = (subj_name, group_label, dt.datetime.today(), json.dumps(data))
            self.cur.execute("INSERT INTO {} (subj_name, group_label, date, data) VALUES(?,?,?,?)".format(self.table_name), fields)

    def printAllData(self):
        with self.conn:
            self.cur.execute("SELECT * FROM {}".format(self.table_name))

            rows = self.cur.fetchall()

            for row in rows:
                print row

    def sendLastHourOfData(self):
        with self.conn:
            lid = self.cur.lastrowid
            self.cur.execute("SELECT * FROM {} WHERE id='{}';".format(self.table_name, lid))

            row = self.cur.fetchall()

            return row

    def sendAllData(self):
        with self.conn:
            self.cur.execute("SELECT * FROM {}".format(table_name))

            rows = self.cur.fetchall()

            return rows

    #sendAllSegmentsBySubject
    def sendAllSegmentsBySubject(self, subj):
        with self.conn:
            self.cur.execute("SELECT * FROM {} WHERE subj_name='{}';".format(self.table_name, subj))

            rows = self.cur.fetchall()

            return rows

    #sendAllSegmentsByDateRange
    def sendAllSegmentsByDateRange(self, start='2015-05-19', end=dt.datetime.today()):
        with self.conn:
            self.cur.execute("SELECT * FROM {0} WHERE date BETWEEN ".format(self.table_name) +
                "datetime('{0}') AND datetime('{1}');".format(start, end))

            rows = self.cur.fetchall()

            return rows

    #sendAllSegmentsByGroup
    def sendAllSegmentsByGroup(self, group="control"):
        with self.conn:
            self.cur.execute("SELECT * FROM {} WHERE group_label='{}';".format(self.table_name, group))

            rows = self.cur.fetchall()

            return rows



# if __name__ == '__main__':
#     DB = DataStorage()
#     DB.cleanDatabase()
#     DB.bootstrapData()

#     DB.storeLastHourOfData("Morgan S.", "Control",
#         {
#         'num_channels': 2,
#         'channel_labels': ["Pz", "Cz"],
#         'sample_rate': 250,
#         'reference': 2,
#         'data': [[1.01, 1.02], [1.01, 1.02]]
#         })

#     # tmp = raw_input("Do you want to print the database? [Y/N]")

#     # if('Y' in tmp.upper() ):
#     #     DB.printAllData()
#     print "Printing all hardons"
#     print DB.sendAllSegmentsByGroup('Hardons')

#     print "printing AlexR"
#     print DB.sendAllSegmentsBySubject('AlexR')

#     print "printing wide date range"
#     print DB.sendAllSegmentsByDateRange('2015-01-01', '2015-05-20')


