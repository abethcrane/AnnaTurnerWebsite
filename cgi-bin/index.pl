#!/usr/bin/perl

use Cwd;
use CGI;

use CGI;
my $q = CGI->new;

print $q->header('text/html');

sub body();
sub links;
sub default;
sub imageGallery();
sub validDir();

my $directory = getcwd;
my $gallery = "";
if (defined $q->path_info()) {
   $gallery = $q->path_info();
   $gallery =~ s/\///;
}

if (&validDir($gallery)) {
   $gallery = $q->path_info();
} else {
   $gallery = &default();
}

$baseUrl =  $q->script_name();

$JSCRIPT=<<END;
\$(function() {
    \$('.pictures').cycle({
      fx: 'none', 
      speed:  300,  
      timeout: 0 ,
      prev: '#prev',
      next: '#next , .pictures',
      after: onAfter,
      //before: onBefore
   });

   function onAfter(curr,next,opts) {
      var caption =  (opts.currSlide + 1) + " of " + opts.slideCount;
      caption = caption.replace(/(\\r\\n|\\n|\\r)/gm," "); 
      \$('#caption').html(caption);
       caption = curr.src;
       caption = caption.replace(/http.*images\\/.*\\//, '');
       caption = caption.replace(/\\..*?\$/g, '');
       caption = caption.replace(/%20/g, ' ');
       caption = caption.replace(/_/g, ' ');
       caption = caption.replace(/^[0-9]+/g, ' ');
       \$('#titleCaption').html(caption);
   }

    
});
END

print $q->start_html(
    -title=>'Anna Turner Photography',
    -meta=>{'author'=>'Beth Crane',
            'keywords'=>'Anna Turner, Photographer, Sydney',
            'description'=>'Anna Turner Photography; Sydney fine art and fashion photographer',
            'robots'=>'index, follow'
            },
    -style=>{'src'=>'../../style.css'},
    -script=>[
      { -type => 'text/javascript',
        -src   => '../../scripts/jquery.min.js'
      },
      { -type => 'text/javascript',
        -src   => '../../scripts/chili-1.7.pack.js'
      },
      { -type => 'text/javascript',
        -src   => '../../scripts/jquery.cycle.all.js' 
      },
     $JSCRIPT]
);

&body($gallery);

print $q->end_html();

sub body {
my ($dir) = @_;
   print qq(
      <div class="nav">
         <a href="http://annaturner.com.au"><h1><span>Anna Turner Photography</span></h1></a>
         <ul class="links">
);
&links();
  print qq(
            <br/>
            <li><a href="/about">About</a></li>
            <li><a href="/contact">Contact</a></li>
            <li><a href="http://annaturnerphotography.bigcartel.com">Shop</a></li>
            <li><a href="http://annaturner.tumblr.com/">Blog</a></li>
            <li><a href="http://annaturnerweddings.com.au">Weddings</a></li>
         </ul>
      </div>
      <div class="gallery">
         <div class="pictures">
);
&imageGallery($dir);
print qq (
         </div>
         <p class="caption">
            <a href='#'><span id='prev'>&lt; </span></a>
            <span id="caption">$cur of $total</span>
            <a href='#'><span id='next'> &gt;</span></a>
         </p>
       <!--  <p id="titleCaption"></p> -->
      </div>        
   );
}

sub links{

   my $directory = getcwd."/../images/";   
   opendir(DIR, $directory) or die $!;
    
   my @dirs = sort {$a <=> $b} (readdir(DIR));
    # Loop through the array printing out the directory names
    foreach my $dir (@dirs) {
      $_ = $dir;
       if (-d $directory.$dir && !m/^\.*$/) {
         $printdir = $dir;
         $printdir =~ s/_/ /g;
         $printdir =~ s/^[0-9]+//g;
#/cgi-bin/index.pl/
         print "            <li><a href='".lc($dir)."'>".$printdir."</a></li>\n"
       }
    }
    closedir(DIR);            
   
}   

sub default {
   my $directory = getcwd."/../images/";
   my $result  = ""; 
   opendir(DIR, $directory) or die $!;
    
   my @dirs = sort {$a <=> $b} (grep {//} readdir(DIR));
    # Loop through the array printing out the directory names
    foreach my $dir (@dirs) {
    $dir = lc($dir);
      $_ = $dir;
       if (-d $directory.$dir && !m/^\.*$/) {
           $result = $dir;
           last;
       }
    }
    closedir(DIR);            
   return $result;
}   



sub validDir {
   my ($dir) = @_;
   $dir = lc($dir);
   chomp($dir); 

   my $valid = 0;
   my $directory = getcwd."/../images/";   
   opendir(DIR, $directory) or die $!;
   my @dirs = grep {//} readdir(DIR);
    # Loop through the array printing out the directory names
    @dirs = map(lc($_), @dirs);
   chomp(@dirs);
   $_ = $dir;
   if (-d $directory.$dir && !m/^\.*$/) {
      if (grep $_ eq $dir, @dirs) {
         $valid = 1;
      }
   }
    closedir(DIR);  
   return $valid;
}


sub imageGallery {
   my ($dir) = @_;
   $dir = lc($dir);
   my $directory = getcwd."/../images/";
   my $local_dir = "/../images/$dir";
   opendir(NEWDIR, $directory.$dir) or die $!;
   @files = sort {$a <=> $b} (readdir(NEWDIR)); #grep {/(jpg|jpeg|JPG|JPEG|bmp|BMP|png|PNG|gif|GIF|tiff|TIFF)/}
   foreach my $file (@files) {
      if (-f $directory.$dir."/".$file) {
         print qq(            <img src="$local_dir/$file"/>\n);
      }
   }
   closedir(NEWDIR);
}