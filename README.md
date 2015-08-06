# How does your system work? (if not addressed in comments in source)

The system takes a text-file in when initialized and "hashes" the lines in the
file by splitting the file into chunks of (configurable) size. The working
assumption is that access throughout the file will be uniform.

The intent is to balance the overhead of opening a file with the overhead of
scanning a file, and allow for nearly random access in a method similar to a
hash table. The original file is broken up into many smaller files, each with
up to a certain number of lines. The name of each file is the number of the line
of the original file where it starts. The system uses integer division (floor)
to determine which file to look in, and then seeks to the correct line number
within. This guarantees a reasonable maximum scan-time and allows multiple
portions of the file to be read simultaneously.

This makes two key assumptions:
+ Uniform, random access to the lines in the file. If the access is not uniform,
  then the same sub-file will be access repeatedly, and this will cause issues
  with multiple clients blocking each other

+ The file is not too small. If it cannot be broken up enough to spread out the
  requests, it results in the same situation as above.

# How will your system perform with a 1 GB file? a 10 GB file? a 100 GB file?

The system should handle files of increasing size without any real loss in
responsiveness. Because the file is split into multiple files, with a cap at
1024 lines each, no single request will ever need to scan more than 1024 lines.

The calculation for the maximum number of lines increases slowly with the file
size to attempt to balance the number of files split out with keeping the line
count low. Because the file access is random, by name, there is no performance
loss associated with opening a particular file in a larger set.

# How will your system perform with 100 users? 10000 users? 1000000 users?

The system should handle concurrent users to the best extent of the webserver in
front of it. Each file access is relatively fast, and assuming a uniform
distribution of the lines requested, concurrent sessions should not bunch up on
a particular file.

# What documentation, websites, papers, etc did you consult in doing this assignment?

Primarily the ruby documentation on File, IO, and Enumerator. I also consulted
documentation on Sinatra, Rack-Test and Thin. I read a few discussions on
StackOverflow and such about accessing a random line in a file, but they mostly
reinforced the distinction between reading an entire file into memory and
scanning a file.

# What third-party libraries or other tools does the system use? How did you choose each library or framework you used?

**[Sinatra](http://www.sinatrarb.com/)** - small web framework. I did not need the
full power of rails for a single-endpoint api; the controllers, views, and
database abstraction were overkill. Sinatra gives me a lightweight DSL to handle
the http requests/responses.

**[Thin](http://code.macournoyer.com/thin/)** - webserver. It's recommended by
Sinatra and handles multiple requests fast.

# How long did you spend on this exercise? If you had unlimited more time to spend on this, how would you spend it and how would you prioritize each item?

I spent about 7 - 8 hours on this exercise. If I had unlimited time, I would do
the following (in order of priority):

+ Further investigate the method of storing data:
  I think the "files as psuedo-hash-table" is a reasonable solution, but I'm not
  sure it's the best. I considered using various data-stores, including Postgres,
  SQLite, PStore, and Redis, but rejected them because they either were in-memory,
  overkill, or the setup cost was too high because of the `build.sh` requirement.
  One of these, or something else, might be a better solution, and given time I
  could perhaps find it, and also feel confident that I'd have enough time to
  script the setup.

+ Tweaking the parameters for how the text file is split into smaller files -
  max lines/number of files. Both how quickly the line max scales, and what the
  maximum allowable max is.

+ Performance testing: both for very large and very small file sizes, and for
  numbers of concurrent users. I did some very limited testing, however multiple
  concurrent users is difficult to simulate, and I have not had the time to try
  to set up a proper load test.

+ Validation and error handling around the line index parameter in the request

+ Clean up the initialization and configuration. There is file management and a
  reliance on a local tmp directory that are not the cleanest.

+ Finish "gemification":
  package the gem as an executable that can be run from
  the terminal without the need for a `build.sh` or `run.sh`; simply
  `gem-install line-server` and `line-server -f <source-file> -d <data-dir>`

# If you were to critique your code, what would you have to say about it?

I'm generally satisfied with the code. The `Configuration` object and the
`DirectoryCleaner` were born out of an emergency; it may be possible to
eliminate the first with better parameter passing. The second is just a way to
reuse code; there may be a better way to handle it. I'd rather not have to
reference the `Configuration` object out of thin air in `LineReqest`.

There are a few inconsistencies with handling `File` resources, specifically
around closing the file and avoiding repeating calculations with it. ie in the
`LineFinder` the file object gets its own method, and is saved to an instance
variable; there's a method to close the file. In `FileHasher` `file.close` is
called directly.

The path handling could possibly be more robust; there is a lot of string
interpolation. Also, there could be more robust validation on the line index
which is passed to the server. The error handling within the requests themselves
is also a little brittle.
