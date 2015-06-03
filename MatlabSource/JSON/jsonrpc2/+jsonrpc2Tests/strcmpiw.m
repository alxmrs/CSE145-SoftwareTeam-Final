function result = strcmpiw(s1,s2)
    % Perform a string comparison ignoring whitespace.
    % Code courtesy of: http://www.mathworks.com/support/solutions/en/data/1-AUV83D/index.html
    % Slight modification to copied code to keep punctuation in the comparison.
    %
    %    Input:  
    %        s1   (string) first string to compare
    %        s2   (string) second string to compare
    %
    %    Output:
    %        true, if s1 and s2 are the same with whitespace removed; otherwise, false
    
    %Create a regular expression
    %This expression matches any character except a whitespace, comma, period, semicolon, or colon
    exp = '[^ \f\n\r\t\v]*';

    %Find the matches within the string
    clean_s1 = regexp(s1, exp, 'match');
    %Concatenate all matches into a single string
    clean_s1 = [clean_s1{:}];

    %Repeat above for the other string
    clean_s2 = regexp(s2, exp, 'match');
    clean_s2 = [clean_s2{:}];

    %Compare the modified strings
    result = strcmp(clean_s1, clean_s2);
end
