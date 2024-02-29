#Streams
 #In this context, a **streams** is nothing more than *"a sequence of bytes that can be read or written using library functions that hide the details of an underlying device from the application"*. In simple words, a text stream is an input of text from a keyboard, a  file, a network device, ... which can be viewed, changed, examined, and ... via text util commands.
 #Modern programming environments and shells (including bash) use three standard I/O streams:
    # **`stdin`** is the standard input stream, which provides input to commands.
    # **`stdout`** is the standard output stream, which displays output from commands.
    # **`stderr`** is the standard error stream, which displays error output from commands
 # Here we are talking about the **stdin** and viewing or manipulating it via different commands and utilities.

#Viewing commands

 #cat
 #This command simply outputs its input stream (or the filename you give it).
    
    jadi@funlife:~/w/lpic/101$ cat > mydata
    test
    this is the second line
    bye
    jadi@funlife:~/w/lpic/101$ cat mydata
    test
    this is the second line
    bye
    
    
 #- Some common cat switches are `-n` to show line numbers, `-s` to squeeze blanks, `-T` to show tabs, and `-v` to show non-printing characters.

 #bzcat, xzcat, zcat, gzcat
  #There are used to directly `cat` the bz, xz, and Z & gz compressed files. These let you see the contents of compressed files without uncompressing them first.

 #less
 #This is a powerful tool to view larger text files. It can paginate, search and move in text files.
 #Some less common commands are as follows.    
    
    | Command   | Usage                                 |
    | ---       | ---                                   |
    | q         | Exit                                  |
    | /foo      | Searches for foo                      |
    | n         | Next (search)                         |
    | N         | Previous (search)                     |
    | ?foo      | Search backward for foo               |
    | G         | Go to end                             |
    | nG        | Go to line n                          |
    | PageUp, PageDown, UpArrow, DownArrow | You guess! |

 #od
 #This command _dump_s files (Shows files in formats other than text). Normal behavior is OctalDump (showing in base 8):
    
    jadi@funlife:~/w/lpic/101$ od mydata
    0000000 062564 072163 072012 064550 020163 071551 072040 062550
    0000020 071440 061545 067543 062156 066040 067151 005145 074542
    0000040 005145
    0000042
    
    
 #**t** will tell what format to print: `t a` for showing only named characters `t c` for showing escaped chars.
 #You can summarize the two above to `a` and `c`
 #- **A** for choosing how to present offset field:  `A d` for Decimal,  `A o` for Octal,  `A x` for hex  `A n` for None
 #- od is very useful to find problems in your text files - Say finding out if you are using tabs or correct line endings.

#Choosing parts of files
 #split
 #Will split the files. It is very useful for transferring HUGE files on smaller media (say splitting a 3TB file into 8GB parts and moving them to another machine with a USB Disk).
    
    cat mydata
    hello
    this is the second line
    but as you can see we are
    still writing
    and this is getting longer
    .
    .
    and longer
    and longer!
    jadi@funlife:~/w/lpic/101$ ls
    mydata
    jadi@funlife:~/w/lpic/101$ **split -l 2 mydata**
    jadi@funlife:~/w/lpic/101$ ls
    mydata    xaa  xab  xac  xad  xae
    jadi@funlife:~/w/lpic/101$ cat xab
    but as you can see we are
    still writing
    
    
 #- By default, split uses xaa, xab, xac, ... for output file names. It can be changed with `split -l 2 mydata output` which split mydata into outputaa, outputab, ...; 2 lines per file.
 #- the `l 2` splits 2 lines per file. It is possible to use `b 42` to split every 42 bytes or even `n 5` to force 5 output files.
 #- If you want numeric output (x00, x01, ..) use `d` option.
 #- Need to join these files? cat them with cat x* > originalfile.

 #head and tail
 #Will show the beginning (head) or end (tail) of text files. By default, it will show 10 lines but you can change it by `-n20` or `-20`.
 #tail -f follows the new lines which are being written at the end of the file. Very useful.

 #cut
 #The `cut` command will *cut* one or more columns from a file. Good for separating fields
 #Lets cut the *first field* of a file.    
    
    jadi@funlife:~/w/lpic/101$ cat howcool
    jadi    5
    sina    6
    rubic    2
    you     12
    jadi@funlife:~/w/lpic/101$ cut -f1 howcool
    jadi
    sina
    rubic
    you
    
    
 #Default delimiter is TAB. use -dx to change it to "x" or -d' ' to change it to space
 #It is also possible to *cut* fields 1, 2, and 3 with `-f1-3` or only characters with index 4, 5, 7, 8 from each line `-c4,5,7,8`.

#Modifying streams
 #nl
 #This command is for showing line numbers.
    
    jadi@funlife:~/w/lpic/101$ **nl mydata  | head -3**
         1    hello
         2    this is the second line
         3    but as you can see we are
    
    
 #cat -n will also number lines.
 #sort & uniq
 #Will sorts its input(s).
    
    jadi@funlife:~/w/lpic/101$ cat uses
    you fedora
    jadi ubuntu
    rubic windows
    neda mac
    jadi@funlife:~/w/lpic/101$ cat howcool
    jadi    5
    sina    6
    rubic    2
    you     12
    jadi@funlife:~/w/lpic/101$ **sort howcool uses**
    jadi    5
    jadi ubuntu
    neda mac
    rubic    2
    rubic windows
    sina    6
    you     12
    
    
 #- If you want a reverse sort, use the `-r` switch.
 #- If you want to sort NUMERICALLY (so 9 is lower than 19), use `-n`.
 #- And the `uniq` removes duplicate entries from its input. Normal behavior is removing only the duplicated lines but you can change its behavior, for example  `-f1` switch forces it not to check the first field.
    
    jadi@funlife:~/w/lpic/101$ uniq what_i_have.txt
    laptop
    socks
    tshirt
    ball
    socks
    glasses
    jadi@funlife:~/w/lpic/101$ sort what_i_have.txt | uniq
    ball
    glasses
    laptop
    socks
    tshirt
    jadi@funlife:~/w/lpic/101$
    
    
 #- As you can see, the input HAVE TO BE sorted for uniq to work.
 #- uniq has great switches:
    
    jadi@funlife:~/w/lpic/101$ cat what_i_have.txt
    laptop
    socks
    tshirt
    ball
    socks
    glasses
    jadi@funlife:~/w/lpic/101$ sort what_i_have.txt  | uniq -c  #show count of each item
          1 ball
          1 glasses
          1 laptop
          2 socks
          1 tshirt
    jadi@funlife:~/w/lpic/101$ sort what_i_have.txt  | uniq -u #show only non-repeated items
    ball
    glasses
    laptop
    tshirt
    jadi@funlife:~/w/lpic/101$ sort what_i_have.txt  | uniq -d #show only repeated items
    socks
    
    

 #paste
 #The paste command pastes lines from two or more files side-by-side! You cannot do this in a general text editor with ease!    
    
    jadi@funlife:~/w/lpic/101$ cat howcool
    jadi    5
    sina    6
    rubic    2
    you     12
    jadi@funlife:~/w/lpic/101$ cat uses
    you fedora
    jadi ubuntu
    rubic windows
    neda mac
    jadi@funlife:~/w/lpic/101$ paste howcool uses
    jadi    5    you fedora
    sina    6    jadi ubuntu
    rubic    2    rubic windows
    you     12    neda mac
    
    

 #tr
 #The `tr` command *translates* characters in the stream. For example, `tr 'ABC' '123'` will replace A with 1, B with 2, and C with 3 in the provided stream. It is a pure filter and does not accept the input file name. If needed you can pipe the cat with it (see chapter 103.4).
    
    jadi@funlife:~/w/lpic/101$ cat mydata
    hello
    this is the second line
    but as you can see we are
    still writing
    and this is getting longer
    .
    .
    and longer
    and longer!
    jadi@funlife:~/w/lpic/101$ cat mydata | tr 'and' 'AND'
    hello
    this is the second liNe
    but As you cAN see we Are
    still writiNg
    AND this is gettiNg loNger
    .
    .
    AND loNger
    AND loNger!
    
    

 #sed
 #sed is **s**tream **ed**itor. It is POWERFUL and can do things that are not far from magic! Just like most of the tools we've seen far now, sed can work as a filter or take input from a file. Sed is a great tool for replacing text with using **regular expressions** . If you need to replace A with B only once in each line in a stream just issue  `sed 's/A/B/'`:
    
    jadi@funlife:~/w/lpic/101$ cat uses
    you fedora
    jadi ubuntu
    rubic windows
    neda mac
    jadi@funlife:~/w/lpic/101$ sed 's/ubuntu/debian/' uses
    you fedora
    jadi debian
    rubic windows
    neda mac
    jadi@funlife:~/w/lpic/101$
        
 #The pattern for changing EVERY occurrence of A to B in a line is `sed 's/A/B/g'`.
 #Remember escape characters? They also work here and this will remove every *new line* from a file and will replace it with a space:
    
    jadi@funlife:~/w/lpic/101$ cat mydata
    hello
    this is the second line
    but as you can see we are
    still writing
    and this is getting longer
    .
    .
    and longer
    and longer!
    jadi@funlife:~/w/lpic/101$ sed 's/ /\t/g' mydata > mydata.tab
    jadi@funlife:~/w/lpic/101$ cat mydata.tab
    hello
    this    is the second    line
    but    as    you    can    see    we    are
    still    writing
    and    this    is    getting    longer
    .
    .
    and    longer
    and    longer
    

#Getting stats
 #wc
 #The `wc` is *word count*. It counts the lines, words, and bytes in the input stream.
    
    jadi@funlife:~/w/lpic/101$ wc mydata
      9  25 121 mydata    
    
 #It is very common to count the line numbers with -l switch.
 #You should know that if you put `-` instead of a filename, the data will be replaced from the pipe (or keyboard stdin).
    
    jadi@funlife:~/w/lpic/101$ wc -l mydata | cat mydata - mydata  
    hello
    this is the second line
    but as you can see we are
    still writing
    and this is getting longer
    .
    .
    and longer
    and longer!
    9 mydata
    hello
    this is second line
    but as you can see we are
    still writing
    and this is getting longer
    .
    .
    and longer
    and longer!
    ```
    

#Hashing
 #A hash function is any function that can be used to map data of arbitrary size to fixed-size values. There are different hashes and we use them for different purposes. For example, a site may hash your password in its database to keep it secure (and check the hash of provided password with a hash it already has in DB during logins) a site  may provide the hash of a file so you can be sure that you've  downloaded the correct file and ...
 #The hashing algorithms covered in LPIC1 are:
    #- md5sum
    #- sha256sum
    #- sha512sum
 #- You can check any file (or input streams hash with something like this):

 jadi@ocean:~$ md5sum /tmp/myfile.txt
 8183aa57a23658efe7ba7aebe60816bc  /tmp/myfile.txt
 jadi@ocean:~$ sha256sum /tmp/myfile.txt
 7ddcfda184b55ee06b0c81e0ad136b1aa4a86daeb1078bcaeccc246eb2c8693b  /tmp/myfile.txt
 jadi@ocean:~$ sha512sum /tmp/myfile.txt
 79e5d789528e5e55fc1bddcb381afd56e896b1b452347a76777fb38d76c9754278700036f35df2a53c4d53d3e3623538a8b9ed155a3fd5275e667bdbf3c0b359  /tmp/myfile.txt


 #- As you can see, `sha512sum` creates a longer hash which is more secure.