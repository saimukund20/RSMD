use Tk;
use Tk::BrowseEntry;
$mw = MainWindow->new(-title=>'RSMD');
$mw->geometry(($mw->maxsize())[0] .'x'.($mw->maxsize())[0]);
$fm_menu = $mw->Frame(-relief=>'groove',-borderwidth=>5);
$fm_menu->pack(-side=>'top',-expand=>0,-fill=>'x');
$mn_sec = $fm_menu->Menubutton(-tearoff=>0,-text=>'Repeat Searcher',-menuitems=>[
['command'=>'Single protein sequence',-command=>\&psf],
['command'=>'Batch protein sequences',-command=>\&mpsf]],-font=>[-size =>'10'])->pack(-side=>'left');
$mn_sec = $fm_menu->Menubutton(-tearoff=>0,-text=>'Motif Detector',-menuitems=>[
['command'=>'Single protein sequence',-command=>\&mh]],-font=>[-size =>'10'])->pack(-side=>'left');
$mn_sec = $fm_menu->Menubutton(-tearoff=>0,-text=>'Similarity Search',-menuitems=>[
['command'=>'Multiple Alignment',-command=>\&ma]],-font=>[-size =>'10'])->pack(-side=>'left');
$mn_sec = $fm_menu->Menubutton(-tearoff=>0,-text=>'Prosite Pattern finder',-menuitems=>[
['command'=>'Single protein sequence',-command=>\&profs]],-font=>[-size =>'10'])->pack(-side=>'left');
$mn_help = $fm_menu->Menubutton(-tearoff=>0,-text=>'Help',-menuitems=>[
['command'=>'RSMD Help Center',-command=>\&show_help]],-font=>[-size =>'10'])->pack(-side=>'left');
$mn_help->pack(-side=>'left');
$fm_gr = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr1 = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr2 = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$midframe = $mw->Frame();
($help_about = <<EOHD) =~ s/^\t//gm;
Copyright (c) 2013 @ SASTRA University by Sadhana Ravishankar and Sai Mukund.R guided by Ast.Prof. Uday Kumar. M. 

This is an intergrated Repeat Searcher and Motid Detector.

The methods of using the tool   

1. Repeat Searcher : Used to identify repeats in single/multiple sequence(s).

2. Motif Detector : Used to identify motifs in single sequence.

3. Similarity Search : Used to identify repeats from a multiple sequence alignment.

4. Prosite Pattern Hunter : Used to identify repeats in single sequence based on the given prosite pattern.

For any further queries please go through the RSMD - Tutorial.pdf file.
EOHD
sub show_help 
{
$mw_help = MainWindow->new(-title=>'Tool Guide');
$mw_help->geometry(($mw_help->maxsize())[0] .'x'.($mw_help->maxsize())[1]);
my $fm_help = $mw_help->Frame(-relief=>'flat',-borderwidth=>5);
my $tx_help = $fm_help->Scrolled('Text');
$tx_help->pack(-side=>'top',-expand=>1,-fill=>'both');
$fm_help->pack(-side=>'top',-expand=>1,-fill=>'both');
$tx_help->insert('end', $help_about);
MainLoop;
}
MainLoop;
sub psf
{
$fm_gr->destroy();
$fm_gr1->destroy();
$fm_gr2->destroy();
$midframe->destroy();
$fm_gr = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr->pack(-side=>'top',-expand=>0,-fill=>'x');
$fm_gr1 = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr2 = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$midframe = $mw->Frame();
$down=$fm_gr->Button(-text=>"Upload text file",-font=>[-size =>'10'],-command=>\&upload)->pack(-side=>"left");
$entry=$fm_gr->Entry(-width=>"40",-background=>"lightgreen")->pack(-side=>"left");
$down=$fm_gr->Button(-text=>"Match",-font=>[-size =>'10'],-command=>\&match)->pack(-side=>"right");
@value=('1aa','2aa','3aa','4aa','5aa');
my $dropdownq = $fm_gr->BrowseEntry(-label => "               Select the pattern length to match",-font=>[-size =>'10'],-variable => \$dropdown_valueq)->pack(-anchor=>'nw',-side=>'left');
foreach(@value) 
{
$dropdownq->insert('end', $_);
}
sub upload
{
$text=$mw->getOpenFile();
$entry->insert('0.0',"$text");
}
sub match
{
if($text ne "")
{
$fm_gr1->destroy();
$fm_gr2->destroy();
$midframe->destroy();
$fm_gr2 = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr2->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_gr);
$fm_gr1 = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr1->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_gr2);
$midframe = $mw->Frame()->pack();
open(FW,"$text");
$seq="";
$flag=0;
while(<FW>)
{
if($_=~/^>/)
{
$flag=1;
}
else
{
$flag=0;
}
if($flag == 0)
{
chomp($_);
$seq.=$_;
}
}
$ccc=0;
for($i=0;$i<length($seq);$i++)
{
$fko=substr($seq,$i,1);
if($fko eq "B" || $fko eq "J" || $fko eq "O" || $fko eq "U" || $fko eq "X" || $fko eq "Z")
{
$ccc++;
}
}
$dd=$dropdown_valueq;
$choice=substr($dd,0,1);
if($choice ne "")
{
if($ccc == 0)
{
$c=$fm_gr1->Canvas(-width => 1400, -height =>40); 
$c->pack;
$cccc=0;
for($i=0;$i<length($seq);$i++)
{
$fko=substr($seq,$i,1);
if($fko eq "A" || $fko eq "T" || $fko eq "G" || $fko eq "C")
{
$cccc++;
}
}
$found="";
if($cccc/length($seq) == 1)
{
$found="DNA";
}
else
{
$found="PROTEIN";
}
%color=(
'A'=>'#FF0202','R'=>'#FF02A3','N'=>'#BC02FF','D'=>'#5F02FF','C'=>'#0206FF','E'=>'#02EFFF',
'Q'=>'#02FF0B','G'=>'#C5FF02','H'=>'#FFAB02','I'=>'#FF6802','L'=>'#FF2802','K'=>'#BFB1AE',
'M'=>'#4B0F38','F'=>'#072A19','P'=>'#92F696','S'=>'#000000','T'=>'#FFFFFF','W'=>'#5B0003',
'Y'=>'#6C620A','V'=>'#151B54');
$midframe->destroy();
$n=1220/length($seq);
$o=length($seq);
for($i=100;$i<1320;)
{
$c->createLine($i,35,$i+$n,35,-fill=>"green");
$i+=$n;
}
if(length($seq) > 0 && length($seq) <= 50)
{
$j=0;
$k=0;
for($i=100;$i<1320;)
{
$c->createText($i,25,-fill =>'black',-font=>[-size =>'10'],-text =>"$j");
$c->createLine($i,28,$i,40,-fill=>"red");
$i+=$n;
$j++;
}
}
elsif(length($seq) > 50 && length($seq) <= 100)
{
$j=0;
$k=0;
for($i=100;$i<1320;)
{
if($j == $k*5)
{
$c->createText($i,25,-fill =>'black',-font=>[-size =>'10'],-text =>"$j");
$c->createLine($i,28,$i,40,-fill=>"red");
$k++;
}
$i+=$n;
$j++;
}
}
elsif(length($seq) > 100 && length($seq) <= 1000)
{
$j=0;
$k=0;
for($i=100;$i<1320;)
{
if($j == $k*20)
{
$c->createText($i,25,-fill =>'black',-font=>[-size =>'10'],-text =>"$j");
$c->createLine($i,28,$i,40,-fill=>"red");
$k++;
}
$i+=$n;
$j++;
}
}
elsif(length($seq) > 1000)
{
$j=0;
$k=0;
for($i=100;$i<1320;)
{
if($j == $k*100)
{
$c->createText($i,25,-fill =>'black',-font=>[-size =>'10'],-text =>"$j");
$c->createLine($i,28,$i,40,-fill=>"red");
$k++;
}
$i+=$n;
$j++;
}
}
@seq1=();
@seq2=();
$dd=$dropdown_valueq;
$choice=substr($dd,0,1);
$rr=$choice-1;
for($i=0;$i<length($seq)-$rr;$i++)
{
$ch=substr($seq,$i,$choice);
push(@seq2,$ch);
}
push(@seq1,$seq2[0]);
for($i=0;$i<scalar(@seq2);$i++)
{
$count=0;
for($j=0;$j<scalar(@seq1);$j++)
{
if($seq2[$i] eq $seq1[$j])
{
$count++;
}
}
if($count == 0)
{
push(@seq1,$seq2[$i]);
}
}
$num_channels = scalar(@seq1);
######################
#dont touch
######################
$midframe = $mw->Frame()->pack();
$midframel = $midframe->Frame(-relief=>'sunken',-borderwidth=>5)->pack(-side=>'left',-expand=>1,-fill=>'y');
$midframer = $midframe->Frame(-relief=>'sunken',-borderwidth=>5)->pack(-side=>'right');
$midframer1 = $midframer->Frame(-relief=>'sunken',-borderwidth=>5)->pack(-side=>'top');
$yscroll = $midframer1->Scrollbar( 
-orient  => 'vertical',
-command => \&yscrollit,
-background=>'red'
)->pack(-side=>'right',-fill=>'y');
$canvasp = $midframer1->Canvas(-bg =>'white',-width=>1250,-height=>611,
-scrollregion=>[-10,0,7450,(33 * $num_channels)],         
-yscrollincrement => 1,         
-yscrollcommand => ['set', $yscroll ])->pack(-side=>'left');
$canvass = $midframel->Canvas(-bg =>'lightseagreen',-width=>75,-height=>611,
-scrollregion=>[-10,0,7450,(33 * $num_channels)], 
-yscrollincrement => 1)->pack(-side=>'top');
######################
#Displaying text
######################
if($found eq "PROTEIN")
{
$l1=$fm_gr2->Label(-text=>"$found sequence key",-font=>[-size=>"10",-weight =>'bold'])->pack(-side=>'left',-anchor=>'nw');
$l1=$fm_gr2->Label(-text=>"A",-font=>[-size=>"10",-weight =>'bold'],-foreground=>"#FF0202")->pack(-side=>'left',-anchor=>'nw');
$l1=$fm_gr2->Label(-text=>"C",-font=>[-size=>"10",-weight =>'bold'],-foreground=>"#0206FF")->pack(-side=>'left',-anchor=>'nw');
$l1=$fm_gr2->Label(-text=>"D",-font=>[-size=>"10",-weight =>'bold'],-foreground=>"#5F02FF")->pack(-side=>'left',-anchor=>'nw');
$l1=$fm_gr2->Label(-text=>"E",-font=>[-size=>"10",-weight =>'bold'],-foreground=>"#02EFFF")->pack(-side=>'left',-anchor=>'nw');
$l1=$fm_gr2->Label(-text=>"F",-font=>[-size=>"10",-weight =>'bold'],-foreground=>"#072A19")->pack(-side=>'left',-anchor=>'nw');
$l1=$fm_gr2->Label(-text=>"G",-font=>[-size=>"10",-weight =>'bold'],-foreground=>"#C5FF02")->pack(-side=>'left',-anchor=>'nw');
$l1=$fm_gr2->Label(-text=>"H",-font=>[-size=>"10",-weight =>'bold'],-foreground=>"#FFAB02")->pack(-side=>'left',-anchor=>'nw');
$l1=$fm_gr2->Label(-text=>"I",-font=>[-size=>"10",-weight =>'bold'],-foreground=>"#FF6802")->pack(-side=>'left',-anchor=>'nw');
$l1=$fm_gr2->Label(-text=>"K",-font=>[-size=>"10",-weight =>'bold'],-foreground=>"#BFB1AE")->pack(-side=>'left',-anchor=>'nw');
$l1=$fm_gr2->Label(-text=>"L",-font=>[-size=>"10",-weight =>'bold'],-foreground=>"#FF2802")->pack(-side=>'left',-anchor=>'nw');
$l1=$fm_gr2->Label(-text=>"M",-font=>[-size=>"10",-weight =>'bold'],-foreground=>"#4B0F38")->pack(-side=>'left',-anchor=>'nw');
$l1=$fm_gr2->Label(-text=>"N",-font=>[-size=>"10",-weight =>'bold'],-foreground=>"#BC02FF")->pack(-side=>'left',-anchor=>'nw');
$l1=$fm_gr2->Label(-text=>"P",-font=>[-size=>"10",-weight =>'bold'],-foreground=>"#92F696")->pack(-side=>'left',-anchor=>'nw');
$l1=$fm_gr2->Label(-text=>"Q",-font=>[-size=>"10",-weight =>'bold'],-foreground=>"#02FF0B")->pack(-side=>'left',-anchor=>'nw');
$l1=$fm_gr2->Label(-text=>"R",-font=>[-size=>"10",-weight =>'bold'],-foreground=>"#FF02A3")->pack(-side=>'left',-anchor=>'nw');
$l1=$fm_gr2->Label(-text=>"S",-font=>[-size=>"10",-weight =>'bold'],-foreground=>"#000000")->pack(-side=>'left',-anchor=>'nw');
$l1=$fm_gr2->Label(-text=>"T",-font=>[-size=>"10",-weight =>'bold'],-foreground=>"#FFFFFF")->pack(-side=>'left',-anchor=>'nw');
$l1=$fm_gr2->Label(-text=>"V",-font=>[-size=>"10",-weight =>'bold'],-foreground=>"#151B54")->pack(-side=>'left',-anchor=>'nw');
$l1=$fm_gr2->Label(-text=>"W",-font=>[-size=>"10",-weight =>'bold'],-foreground=>"#5B0003")->pack(-side=>'left',-anchor=>'nw');
$l1=$fm_gr2->Label(-text=>"Y",-font=>[-size=>"10",-weight =>'bold'],-foreground=>"#6C620A")->pack(-side=>'left',-anchor=>'nw');
}
else
{
$l1=$fm_gr2->Label(-text=>"$found sequence key",-font=>[-size=>"10",-weight =>'bold'])->pack(-side=>'left',-anchor=>'nw');
$l1=$fm_gr2->Label(-text=>"A",-font=>[-size=>"10",-weight =>'bold'],-foreground=>"#FF0202")->pack(-side=>'left',-anchor=>'nw');
$l1=$fm_gr2->Label(-text=>"C",-font=>[-size=>"10",-weight =>'bold'],-foreground=>"#0206FF")->pack(-side=>'left',-anchor=>'nw');
$l1=$fm_gr2->Label(-text=>"G",-font=>[-size=>"10",-weight =>'bold'],-foreground=>"#C5FF02")->pack(-side=>'left',-anchor=>'nw');
$l1=$fm_gr2->Label(-text=>"T",-font=>[-size=>"10",-weight =>'bold'],-foreground=>"#FFFFFF")->pack(-side=>'left',-anchor=>'nw');
}
$go=1225/length($seq);
@matches=();
for($i=0;$i<scalar(@seq1);$i++)
{
$count=0;
for($j=0;$j<length($seq);$j++)
{
$fgh=substr($seq,$j,$choice);
if($fgh eq $seq1[$i])
{
$count++;
}
}
push(@matches,$count);
}
for($i=0;$i<scalar(@seq1);$i++)
{
$canvass->createText(38,25+$i*33,-text=>"$seq1[$i]($matches[$i])",-font=>[-size =>'7']);
$canvasp->createLine(8,19+$i*33,1225,19+$i*33);
}
for($i=0;$i<scalar(@seq1);$i++)
{
$k=8;
for($j=0;$j<length($seq);$j++)
{
$fp=substr($seq,$j,$choice);
if($seq1[$i] eq $fp)
{
$lk=$rr;
for($p=$choice;$p!=0;$p--)
{
$ghi=substr($fp,$lk,1);
$lk--;
$canvasp->createRectangle(8+($go*$j),15+$i*33,8+($go*$p)+($go*$j),23+$i*33,-fill=>"$color{$ghi}");
}
$canvasp->createText(8+($go*$j),12+$i*33,-fill => 'black',-font=>[-size =>'5'],-text =>$j+1); 
}
}
}
$but=$fm_gr2->Button(-text=>"Find",-command=>\&mutate)->pack(-side=>"right");
$muta=$fm_gr2->Entry(-width=>"40",-background=>"lightgreen")->pack(-side=>"right");
$posi1=$fm_gr2->Label(-text =>"Residue(Single letter code)",-font=>[-size =>'10'])->pack(-side=>'right');
$posi=$fm_gr2->Entry(-width=>"40",-background=>"lightgreen")->pack(-side=>"right");
$muta1=$fm_gr2->Label(-text =>"Position for mutation:   ",-font=>[-size =>'10'])->pack(-side=>'right');
}
else
{
$midframe->destroy();
$rg=$fm_gr2->Label(-text =>"Please enter a valid protein sequence",-font=>[-size =>'10'])->pack(-side=>'top');;
$midframe = $mw->Frame();
$midframel = $midframe->Frame(-relief=>'sunken',-borderwidth=>5);
$midframer = $midframe->Frame(-relief=>'sunken',-borderwidth=>5);
$midframer1 = $midframer->Frame(-relief=>'sunken',-borderwidth=>5);
}
}
else
{
$midframe->destroy();
$rg=$fm_gr2->Label(-text =>"Please choose the amino acid range",-font=>[-size =>'10'])->pack(-side=>'top');;
$midframe = $mw->Frame();
$midframel = $midframe->Frame(-relief=>'sunken',-borderwidth=>5);
$midframer = $midframe->Frame(-relief=>'sunken',-borderwidth=>5);
$midframer1 = $midframer->Frame(-relief=>'sunken',-borderwidth=>5);
}
}
else
{
$fm_gr1->destroy();
$fm_gr2->destroy();
$midframe->destroy();
$fm_gr2 = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr2->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_gr);
$fm_gr1 = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr1->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_gr2);
$rg=$fm_gr2->Label(-text =>"Please select a file with a sequence",-font=>[-size =>'10'])->pack(-side=>'top');;
$midframe = $mw->Frame();
$midframel = $midframe->Frame(-relief=>'sunken',-borderwidth=>5);
$midframer = $midframe->Frame(-relief=>'sunken',-borderwidth=>5);
$midframer1 = $midframer->Frame(-relief=>'sunken',-borderwidth=>5);
}
}
######################
#Scrolling Part
######################
sub yscrollit
{
$fraction = $_[1];
$canvass->yviewMoveto($fraction);
$canvasp->yviewMoveto($fraction);
}
sub mutate
{
$mut=$muta->get();
$pos=$posi->get();
$seqm1=$seq;
$seqm="";
for($i=0;$i<length($seqm1);$i++)
{
if($i+1 == $pos)
{
$seqm.=$mut;
}
else
{
$fi=substr($seqm1,$i,1);
$seqm.=$fi;
}
}
@seq1=();
@seq2=();
$midframe->destroy();
$dd=$dropdown_valueq;
$choice=substr($dd,0,1);
$rr=$choice-1;
for($i=0;$i<length($seqm)-$rr;$i++)
{
$ch=substr($seqm,$i,$choice);
push(@seq2,$ch);
}
push(@seq1,$seq2[0]);
for($i=0;$i<scalar(@seq2);$i++)
{
$count=0;
for($j=0;$j<scalar(@seq1);$j++)
{
if($seq2[$i] eq $seq1[$j])
{
$count++;
}
}
if($count == 0)
{
push(@seq1,$seq2[$i]);
}
}
$num_channels = scalar(@seq1);
######################
#dont touch
######################
$midframe = $mw->Frame()->pack();
$midframel = $midframe->Frame(-relief=>'sunken',-borderwidth=>5)->pack(-side=>'left',-expand=>1,-fill=>'y');
$midframer = $midframe->Frame(-relief=>'sunken',-borderwidth=>5)->pack(-side=>'right');
$midframer1 = $midframer->Frame(-relief=>'sunken',-borderwidth=>5)->pack(-side=>'top');
$yscroll = $midframer1->Scrollbar( 
-orient  => 'vertical',
-command => \&yscrollit,
-background=>'red'
)->pack(-side=>'right',-fill=>'y');
$canvasp = $midframer1->Canvas(-bg =>'white',-width=>1250,-height=>611,
-scrollregion=>[-10,0,7450,(33 * $num_channels)],         
-yscrollincrement => 1,         
-yscrollcommand => ['set', $yscroll ])->pack(-side=>'left');
$canvass = $midframel->Canvas(-bg =>'lightseagreen',-width=>75,-height=>611,
-scrollregion=>[-10,0,7450,(33 * $num_channels)], 
-yscrollincrement => 1)->pack(-side=>'top');
######################
#Displaying text
######################
$go=1225/length($seqm);
@matches=();
for($i=0;$i<scalar(@seq1);$i++)
{
$count=0;
for($j=0;$j<length($seqm);$j++)
{
$fgh=substr($seqm,$j,$choice);
if($fgh eq $seq1[$i])
{
$count++;
}
}
push(@matches,$count);
}
for($i=0;$i<scalar(@seq1);$i++)
{
$canvass->createText(38,25+$i*33,-text=>"$seq1[$i]($matches[$i])",-font=>[-size =>'7']);
$canvasp->createLine(8,19+$i*33,1225,19+$i*33);
}
for($i=0;$i<scalar(@seq1);$i++)
{
$k=8;
for($j=0;$j<length($seqm);$j++)
{
$fp=substr($seqm,$j,$choice);
if($seq1[$i] eq $fp)
{
$lk=$rr;
for($p=$choice;$p!=0;$p--)
{
$ghi=substr($fp,$lk,1);
$lk--;
$canvasp->createRectangle(8+($go*$j),15+$i*33,8+($go*$p)+($go*$j),23+$i*33,-fill=>"$color{$ghi}");
}
$canvasp->createText(8+($go*$j),12+$i*33,-fill => 'black',-font=>[-size =>'5'],-text =>$j+1); 
}
}
}
}
}
sub mpsf
{
$fm_gr->destroy();
$fm_gr1->destroy();
$fm_gr2->destroy();
$midframe->destroy();
$fm_gr = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr->pack(-side=>'top',-expand=>0,-fill=>'x');
$down=$fm_gr->Button(-text=>"Upload text file",-font=>[-size =>'10'],-command=>\&upload1)->pack(-side=>"left");
$entry=$fm_gr->Entry(-width=>"40",-background=>"lightgreen")->pack(-side=>"left");
$down=$fm_gr->Button(-text=>"Match",-font=>[-size =>'10'],-command=>\&match1)->pack(-side=>"right");
$fm_gr1 = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr2 = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$midframe = $mw->Frame();
@value=('1aa','2aa','3aa','4aa','5aa');
my $dropdownq = $fm_gr->BrowseEntry(-label => "               Select the pattern length to match",-font=>[-size =>'10'],-variable => \$dropdown_valueq)->pack(-anchor=>'nw',-side=>'left');
foreach(@value) 
{
$dropdownq->insert('end', $_);
}
sub upload1
{
$text1=$mw->getOpenFile();
$entry->insert('0.0',"$text1");
}
sub match1
{
if($text1 ne "")
{
$fm_gr1->destroy();
$fm_gr2->destroy();
$midframe->destroy();
$fm_gr2 = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr2->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_gr);
$fm_gr1 = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr1->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_gr2);
$midframe = $mw->Frame()->pack();
open(FH,"$text1");
@seqd=();
$seqq="";
$i=0;
$flag=0;
while(<FH>)
{
if($_=~/^>/)
{
$flag=1;
$i++;
}
else
{
$flag=0;
}
if($flag == 0)
{
chomp($_);
$seqd[$i-1].=$_;
}
}
$max=0;
for($i=0;$i<scalar(@seqd);$i++)
{
$rty=length($seqd[$i]);
if($rty>$max)
{
$max=$rty;
$seqq=$seqd[$i];
}
}
$ccc=0;
for($i=0;$i<length($seqq);$i++)
{
$fko=substr($seqq,$i,1);
if($fko eq "B" || $fko eq "J" || $fko eq "O" || $fko eq "U" || $fko eq "X" || $fko eq "Z")
{
$ccc++;
}
}
$dd=$dropdown_valueq;
$choice=substr($dd,0,1);
if($choice ne "")
{
if($ccc == 0)
{
$c=$fm_gr1->Canvas(-width => 1400, -height =>40); 
$c->pack;
$cccc=0;
for($i=0;$i<length($seqq);$i++)
{
$fko=substr($seqq,$i,1);
if($fko eq "A" || $fko eq "T" || $fko eq "G" || $fko eq "C")
{
$cccc++;
}
}
$found="";
if($cccc/length($seqq) == 1)
{
$found="DNA";
}
else
{
$found="PROTEIN";
}
$midframe->destroy();
$o=length($seqq);
$n=1220/length($seqq);
for($i=100;$i<1319;)
{
$c->createLine($i,35,$i+$n,35,-fill=>"green");
$i+=$n;
}
if(length($seqq) > 0 && length($seqq) <= 50)
{
$j=0;
$k=0;
for($i=100;$i<1320;)
{
$c->createText($i,25,-fill =>'black',-font=>[-size =>'10'],-text =>"$j");
$c->createLine($i,28,$i,40,-fill=>"red");
$i+=$n;
$j++;
}
}
elsif(length($seqq) > 50 && length($seqq) <= 100)
{
$j=0;
$k=0;
for($i=100;$i<1320;)
{
if($j == $k*5)
{
$c->createText($i,25,-fill =>'black',-font=>[-size =>'10'],-text =>"$j");
$c->createLine($i,28,$i,40,-fill=>"red");
$k++;
}
$i+=$n;
$j++;
}
}
elsif(length($seqq) > 100 && length($seqq) <= 1000)
{
$j=0;
$k=0;
for($i=100;$i<1320;)
{
if($j == $k*10)
{
$c->createText($i,25,-fill =>'black',-font=>[-size =>'10'],-text =>"$j");
$c->createLine($i,28,$i,40,-fill=>"red");
$k++;
}
$i+=$n;
$j++;
}
}
elsif(length($seqq) > 1000)
{
$j=0;
$k=0;
for($i=100;$i<1320;)
{
if($j == $k*100)
{
$c->createText($i,25,-fill =>'black',-font=>[-size =>'10'],-text =>"$j");
$c->createLine($i,28,$i,40,-fill=>"red");
$k++;
}
$i+=$n;
$j++;
}
}
@one=();
@two=();
@three=();
@four=();
$dd=$dropdown_valueq;
$choice=substr($dd,0,1);
$rr=$choice-1;
for($i=0;$i<scalar(@seqd);$i++)
{
for($k=0;$k<length($seqd[$i])-$rr;$k++)
{
$fhj=substr($seqd[$i],$k,$choice);
$one[$i][$k]=$fhj;
}
}
$df=$one[0][0];
$two[0][0]=$df;
for($i=0;$i<scalar(@one);$i++)
{
for($j=0;$j<=$#{$one[$i]} ;$j++)
{
$count=0;
for($k=0;$k<=$#{$two[$i]};$k++)
{
if($one[$i][$j] eq $two[$i][$k])
{
$count++;
}
}
if($count == 0)
{
$two[$i][$k]=$one[$i][$j];
}
}
}
$ddf=$two[0][0];
push(@three,$ddf);
for($i=0;$i<scalar(@two);$i++)
{
for($j=0;$j<=$#{$two[$i]} ;$j++)
{
$count=0;
for($k=0;$k<scalar(@three);$k++)
{
if($two[$i][$j] eq $three[$k])
{
$count++;
}
}
if($count == 0)
{
$ddfff=$two[$i][$j];
push(@three,$ddfff);
}
}
}
%colo1r=(
'A'=>'#FF0202','R'=>'#FF02A3','N'=>'#BC02FF','D'=>'#5F02FF','C'=>'#0206FF','E'=>'#02EFFF',
'Q'=>'#02FF0B','G'=>'#C5FF02','H'=>'#FFAB02','I'=>'#FF6802','L'=>'#FF2802','K'=>'#BFB1AE',
'M'=>'#4B0F38','F'=>'#072A19','P'=>'#92F696','S'=>'#000000','T'=>'#FFFFFF','W'=>'#5B0003',
'Y'=>'#6C620A','V'=>'#151B54');
$go=1225/length($seqq);
@matches=();
for($i=0;$i<scalar(@three);$i++)
{
for($j=0;$j<scalar(@seqd);$j++)
{
$count=0;
for($k=0;$k<length($seqd[$j]);$k++)
{
$fgh=substr($seqd[$j],$k,$choice);
if($fgh eq $three[$i])
{
$count++;
}
}
push(@matches,$count);
}
}
$num_channels = scalar(@three)*scalar(@seqd);
######################
#dont touch
######################
$midframe = $mw->Frame()->pack();
$midframel = $midframe->Frame(-relief=>'sunken',-borderwidth=>5)->pack(-side=>'left',-expand=>1,-fill=>'y');
$midframer = $midframe->Frame(-relief=>'sunken',-borderwidth=>5)->pack(-side=>'right');
$midframer1 = $midframer->Frame(-relief=>'sunken',-borderwidth=>5)->pack(-side=>'top');
$yscroll = $midframer1->Scrollbar( 
-orient  => 'vertical',
-command => \&yscrollit,
-background=>'red'
)->pack(-side=>'right',-fill=>'y');
$canvasp = $midframer1->Canvas(-bg =>'white',-width=>1250,-height=>611,
-scrollregion=>[-10,0,7450,(33 * $num_channels)],         
-yscrollincrement => 1,         
-yscrollcommand => ['set', $yscroll ])->pack(-side=>'left');
$canvass = $midframel->Canvas(-bg =>'lightseagreen',-width=>75,-height=>611,
-scrollregion=>[-10,0,7450,(33 * $num_channels)], 
-yscrollincrement => 1)->pack(-side=>'top');
######################
#Displaying text
######################
if($found eq "PROTEIN")
{
$l1=$fm_gr2->Label(-text=>"$found sequence key",-font=>[-size=>"10",-weight =>'bold'])->pack(-side=>'left',-anchor=>'nw');
$l1=$fm_gr2->Label(-text=>"A",-font=>[-size=>"10",-weight =>'bold'],-foreground=>"#FF0202")->pack(-side=>'left',-anchor=>'nw');
$l1=$fm_gr2->Label(-text=>"C",-font=>[-size=>"10",-weight =>'bold'],-foreground=>"#0206FF")->pack(-side=>'left',-anchor=>'nw');
$l1=$fm_gr2->Label(-text=>"D",-font=>[-size=>"10",-weight =>'bold'],-foreground=>"#5F02FF")->pack(-side=>'left',-anchor=>'nw');
$l1=$fm_gr2->Label(-text=>"E",-font=>[-size=>"10",-weight =>'bold'],-foreground=>"#02EFFF")->pack(-side=>'left',-anchor=>'nw');
$l1=$fm_gr2->Label(-text=>"F",-font=>[-size=>"10",-weight =>'bold'],-foreground=>"#072A19")->pack(-side=>'left',-anchor=>'nw');
$l1=$fm_gr2->Label(-text=>"G",-font=>[-size=>"10",-weight =>'bold'],-foreground=>"#C5FF02")->pack(-side=>'left',-anchor=>'nw');
$l1=$fm_gr2->Label(-text=>"H",-font=>[-size=>"10",-weight =>'bold'],-foreground=>"#FFAB02")->pack(-side=>'left',-anchor=>'nw');
$l1=$fm_gr2->Label(-text=>"I",-font=>[-size=>"10",-weight =>'bold'],-foreground=>"#FF6802")->pack(-side=>'left',-anchor=>'nw');
$l1=$fm_gr2->Label(-text=>"K",-font=>[-size=>"10",-weight =>'bold'],-foreground=>"#BFB1AE")->pack(-side=>'left',-anchor=>'nw');
$l1=$fm_gr2->Label(-text=>"L",-font=>[-size=>"10",-weight =>'bold'],-foreground=>"#FF2802")->pack(-side=>'left',-anchor=>'nw');
$l1=$fm_gr2->Label(-text=>"M",-font=>[-size=>"10",-weight =>'bold'],-foreground=>"#4B0F38")->pack(-side=>'left',-anchor=>'nw');
$l1=$fm_gr2->Label(-text=>"N",-font=>[-size=>"10",-weight =>'bold'],-foreground=>"#BC02FF")->pack(-side=>'left',-anchor=>'nw');
$l1=$fm_gr2->Label(-text=>"P",-font=>[-size=>"10",-weight =>'bold'],-foreground=>"#92F696")->pack(-side=>'left',-anchor=>'nw');
$l1=$fm_gr2->Label(-text=>"Q",-font=>[-size=>"10",-weight =>'bold'],-foreground=>"#02FF0B")->pack(-side=>'left',-anchor=>'nw');
$l1=$fm_gr2->Label(-text=>"R",-font=>[-size=>"10",-weight =>'bold'],-foreground=>"#FF02A3")->pack(-side=>'left',-anchor=>'nw');
$l1=$fm_gr2->Label(-text=>"S",-font=>[-size=>"10",-weight =>'bold'],-foreground=>"#000000")->pack(-side=>'left',-anchor=>'nw');
$l1=$fm_gr2->Label(-text=>"T",-font=>[-size=>"10",-weight =>'bold'],-foreground=>"#FFFFFF")->pack(-side=>'left',-anchor=>'nw');
$l1=$fm_gr2->Label(-text=>"V",-font=>[-size=>"10",-weight =>'bold'],-foreground=>"#151B54")->pack(-side=>'left',-anchor=>'nw');
$l1=$fm_gr2->Label(-text=>"W",-font=>[-size=>"10",-weight =>'bold'],-foreground=>"#5B0003")->pack(-side=>'left',-anchor=>'nw');
$l1=$fm_gr2->Label(-text=>"Y",-font=>[-size=>"10",-weight =>'bold'],-foreground=>"#6C620A")->pack(-side=>'left',-anchor=>'nw');
}
else
{
$l1=$fm_gr2->Label(-text=>"$found sequence key",-font=>[-size=>"10",-weight =>'bold'])->pack(-side=>'left',-anchor=>'nw');
$l1=$fm_gr2->Label(-text=>"A",-font=>[-size=>"10",-weight =>'bold'],-foreground=>"#FF0202")->pack(-side=>'left',-anchor=>'nw');
$l1=$fm_gr2->Label(-text=>"C",-font=>[-size=>"10",-weight =>'bold'],-foreground=>"#0206FF")->pack(-side=>'left',-anchor=>'nw');
$l1=$fm_gr2->Label(-text=>"G",-font=>[-size=>"10",-weight =>'bold'],-foreground=>"#C5FF02")->pack(-side=>'left',-anchor=>'nw');
$l1=$fm_gr2->Label(-text=>"T",-font=>[-size=>"10",-weight =>'bold'],-foreground=>"#FFFFFF")->pack(-side=>'left',-anchor=>'nw');
}
$k=0;
for($i=0;$i<scalar(@three);$i++)
{
$fr=1;
for($j=0;$j<scalar(@seqd);$j++)
{
$canvass->createText(38,25+$k*33,-text=>"$three[$i]"."[$fr]"."($matches[$k])",-font=>[-size =>'7']);
$canvasp->createLine(8,19+$k*33,1225,19+$k*33);
$k++;
$fr++;
}
}
$rv=0;
for($i=0;$i<scalar(@three);$i++)
{
for($j=0;$j<scalar(@seqd);$j++)
{
for($k=0;$k<length($seqd[$j]);$k++)
{
$fgl=substr($seqd[$j],$k,$choice);
if($fgl eq $three[$i])
{
$lk=$rr;
for($p=$choice;$p!=0;$p--)
{
$ghi=substr($fgl,$lk,1);
$lk--;
$canvasp->createRectangle(8+($go*$k),15+$rv*33,8+($go*$p)+($go*$k),23+$rv*33,-fill=>"$colo1r{$ghi}");
}
$canvasp->createText(8+($go*$k),12+$rv*33,-fill => 'black',-font=>[-size =>'5'],-text =>$k); 
}
}
$rv++;
}
}
$but=$fm_gr2->Button(-text=>"Find",-command=>\&mutate1)->pack(-side=>"right");
$muta=$fm_gr2->Entry(-width=>"40",-background=>"lightgreen")->pack(-side=>"right");
$posi1=$fm_gr2->Label(-text =>"Residue(Single letter code)",-font=>[-size =>'10'])->pack(-side=>'right');
$posi=$fm_gr2->Entry(-width=>"40",-background=>"lightgreen")->pack(-side=>"right");
$muta1=$fm_gr2->Label(-text =>"Position for mutation:   ",-font=>[-size =>'10'])->pack(-side=>'right');
}
else
{
$midframe->destroy();
$rg=$fm_gr2->Label(-text =>"Please enter a valid protein sequence",-font=>[-size =>'10'])->pack(-side=>'top');;
$midframe = $mw->Frame();
$midframel = $midframe->Frame(-relief=>'sunken',-borderwidth=>5);
$midframer = $midframe->Frame(-relief=>'sunken',-borderwidth=>5);
$midframer1 = $midframer->Frame(-relief=>'sunken',-borderwidth=>5);
}
}
else
{
$midframe->destroy();
$rg=$fm_gr2->Label(-text =>"Please choose the amino acid range",-font=>[-size =>'10'])->pack(-side=>'top');;
$midframe = $mw->Frame();
$midframel = $midframe->Frame(-relief=>'sunken',-borderwidth=>5);
$midframer = $midframe->Frame(-relief=>'sunken',-borderwidth=>5);
$midframer1 = $midframer->Frame(-relief=>'sunken',-borderwidth=>5);
}
}
else
{
$fm_gr1->destroy();
$fm_gr2->destroy();
$midframe->destroy();
$fm_gr2 = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr2->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_gr);
$fm_gr1 = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr1->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_gr2);
$rg=$fm_gr2->Label(-text =>"Please select a file with a sequence",-font=>[-size =>'10'])->pack(-side=>'top');;
$midframe = $mw->Frame();
$midframel = $midframe->Frame(-relief=>'sunken',-borderwidth=>5);
$midframer = $midframe->Frame(-relief=>'sunken',-borderwidth=>5);
$midframer1 = $midframer->Frame(-relief=>'sunken',-borderwidth=>5);
}
}
######################
#Scrolling Part
######################
sub yscrollit
{
$fraction = $_[1];
$canvass->yviewMoveto($fraction);
$canvasp->yviewMoveto($fraction);
}
sub mutate1
{
$mut=$muta->get();
$pos=$posi->get();
@seqdm1=@seqd;
@seqdm=();
$nm=0;
for($i=0;$i<scalar(@seqdm1);$i++)
{
for($j=0;$j<length($seqdm1[$i]);$j++)
{
if($j+1 == $pos)
{
$seqdm[$nm].=$mut;
}
else
{
$qw=substr($seqdm1[$i],$j,1);
$seqdm[$nm].=$qw;
}
}
$nm++;
}
$midframe->destroy();
$midframe = $mw->Frame()->pack();
@one1=();
@two1=();
@three1=();
$dd=$dropdown_valueq;
$choice=substr($dd,0,1);
$rr=$choice-1;
for($i=0;$i<scalar(@seqdm);$i++)
{
for($k=0;$k<length($seqdm[$i])-$rr;$k++)
{
$fhj=substr($seqdm[$i],$k,$choice);
$one1[$i][$k]=$fhj;
}
}
$df=$one1[0][0];
$two1[0][0]=$df;
for($i=0;$i<scalar(@one1);$i++)
{
for($j=0;$j<=$#{$one1[$i]} ;$j++)
{
$count=0;
for($k=0;$k<=$#{$two1[$i]};$k++)
{
if($one1[$i][$j] eq $two1[$i][$k])
{
$count++;
}
}
if($count == 0)
{
$two1[$i][$k]=$one1[$i][$j];
}
}
}
$ddf=$two1[0][0];
push(@three1,$ddf);
for($i=0;$i<scalar(@two1);$i++)
{
for($j=0;$j<=$#{$two1[$i]} ;$j++)
{
$count=0;
for($k=0;$k<scalar(@three1);$k++)
{
if($two1[$i][$j] eq $three1[$k])
{
$count++;
}
}
if($count == 0)
{
$ddfff=$two1[$i][$j];
push(@three1,$ddfff);
}
}
}
%colo1r=(
'A'=>'#FF0202','R'=>'#FF02A3','N'=>'#BC02FF','D'=>'#5F02FF','C'=>'#0206FF','E'=>'#02EFFF',
'Q'=>'#02FF0B','G'=>'#C5FF02','H'=>'#FFAB02','I'=>'#FF6802','L'=>'#FF2802','K'=>'#BFB1AE',
'M'=>'#4B0F38','F'=>'#072A19','P'=>'#92F696','S'=>'#000000','T'=>'#FFFFFF','W'=>'#5B0003',
'Y'=>'#6C620A','V'=>'#151B54');
$go=1225/length($seqq);
@matches1=();
for($i=0;$i<scalar(@three1);$i++)
{
for($j=0;$j<scalar(@seqdm);$j++)
{
$count=0;
for($k=0;$k<length($seqdm[$j]);$k++)
{
$fgh=substr($seqdm[$j],$k,$choice);
if($fgh eq $three1[$i])
{
$count++;
}
}
push(@matches1,$count);
}
}
$num_channels = scalar(@three1)*scalar(@seqdm);
######################
#dont touch
######################
$midframe = $mw->Frame()->pack();
$midframel = $midframe->Frame(-relief=>'sunken',-borderwidth=>5)->pack(-side=>'left',-expand=>1,-fill=>'y');
$midframer = $midframe->Frame(-relief=>'sunken',-borderwidth=>5)->pack(-side=>'right');
$midframer1 = $midframer->Frame(-relief=>'sunken',-borderwidth=>5)->pack(-side=>'top');
$yscroll = $midframer1->Scrollbar( 
-orient  => 'vertical',
-command => \&yscrollit,
-background=>'red'
)->pack(-side=>'right',-fill=>'y');
$canvasp = $midframer1->Canvas(-bg =>'white',-width=>1250,-height=>611,
-scrollregion=>[-10,0,7450,(33 * $num_channels)],         
-yscrollincrement => 1,         
-yscrollcommand => ['set', $yscroll ])->pack(-side=>'left');
$canvass = $midframel->Canvas(-bg =>'lightseagreen',-width=>75,-height=>611,
-scrollregion=>[-10,0,7450,(33 * $num_channels)], 
-yscrollincrement => 1)->pack(-side=>'top');
######################
#Displaying text
######################
$k=0;
for($i=0;$i<scalar(@three1);$i++)
{
$fr=1;
for($j=0;$j<scalar(@seqdm);$j++)
{
$canvass->createText(38,25+$k*33,-text=>"$three1[$i]"."[$fr]"."($matches1[$k])",-font=>[-size =>'7']);
$canvasp->createLine(8,19+$k*33,1225,19+$k*33);
$k++;
$fr++;
}
}
$rv=0;
for($i=0;$i<scalar(@three1);$i++)
{
for($j=0;$j<scalar(@seqdm);$j++)
{
for($k=0;$k<length($seqdm[$j]);$k++)
{
$fgl=substr($seqdm[$j],$k,$choice);
if($fgl eq $three1[$i])
{
$lk=$rr;
for($p=$choice;$p!=0;$p--)
{
$ghi=substr($fgl,$lk,1);
$lk--;
$canvasp->createRectangle(8+($go*$k),15+$rv*33,8+($go*$p)+($go*$k),23+$rv*33,-fill=>"$colo1r{$ghi}");
}
$canvasp->createText(8+($go*$k),12+$rv*33,-fill => 'black',-font=>[-size =>'5'],-text =>$k); 
}
}
$rv++;
}
}
}
}
sub mh
{
$fm_gr->destroy();
$fm_gr1->destroy();
$fm_gr2->destroy();
$midframe->destroy();
$fm_gr = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr->pack(-side=>'top',-expand=>0,-fill=>'x');
$fm_gr1 = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr2 = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$down=$fm_gr->Button(-text=>"Upload text file",-font=>[-size =>'10'],-command=>\&upload2)->pack(-side=>"left");
$entry=$fm_gr->Entry(-width=>"40",-background=>"lightgreen")->pack(-side=>"left");
$down=$fm_gr->Button(-text=>"Match",-font=>[-size =>'10'],-command=>\&match2)->pack(-side=>"right");
$midframe = $mw->Frame();
sub upload2
{
$text3=$mw->getOpenFile();
$entry->insert('0.0',"$text3");
}
sub match2
{
if($text3 ne "")
{
$fm_gr1->destroy();
$fm_gr2->destroy();
$midframe->destroy();
$fm_gr1 = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr1->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_gr);
$fm_gr2 = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr2->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_gr1);
$c=$fm_gr2->Canvas(-width => 1400, -height =>40); 
$c->pack;
$midframe = $mw->Frame()->pack();
open(FW,"$text3");
$seq="";
while(<FW>)
{
$seq.=$_;
}
$ccc=0;
for($i=0;$i<length($seq);$i++)
{
$fko=substr($seq,$i,1);
if($fko eq "B" || $fko eq "J" || $fko eq "O" || $fko eq "U" || $fko eq "X" || $fko eq "Z")
{
$ccc++;
}
}
if($ccc == 0)
{
$fm_gr1->destroy();
$fm_gr2->destroy();
$midframe->destroy();
$fm_gr1 = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr1->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_gr);
$fm_gr2 = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr2->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_gr1);
$midframe = $mw->Frame()->pack();
$label=$fm_gr1->Label(-text=>"    Please enter the number of residues you want to display before the motifs")->pack(-anchor=>'nw',-side=>'left');
$before=$fm_gr1->Entry(-text=>"0",-width=>"40",-background=>"lightgreen")->pack(-side=>"left");
$label=$fm_gr1->Label(-text=>"    Please enter the number of residues you want to display after the motifs")->pack(-anchor=>'nw',-side=>'left');
$after=$fm_gr1->Entry(-text=>"0",-width=>"40",-background=>"lightgreen")->pack(-side=>"left");
$down=$fm_gr1->Button(-text=>"Match",-font=>[-size =>'10'],-command=>\&findit)->pack(-side=>"right");
}
else
{
$midframe->destroy();
$rg=$fm_gr2->Label(-text =>"Please enter a valid protein sequence",-font=>[-size =>'10'])->pack(-side=>'top');
$midframe = $mw->Frame();
$midframel = $midframe->Frame(-relief=>'sunken',-borderwidth=>5);
$midframer = $midframe->Frame(-relief=>'sunken',-borderwidth=>5);
$midframer1 = $midframer->Frame(-relief=>'sunken',-borderwidth=>5);
}
}
else
{
$fm_gr1->destroy();
$fm_gr2->destroy();
$midframe->destroy();
$fm_gr2 = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr2->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_gr);
$fm_gr1 = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr1->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_gr2);
$rg=$fm_gr2->Label(-text =>"Please choose a file with a sequence",-font=>[-size =>'10'])->pack(-side=>'top');;
$midframe = $mw->Frame();
$midframel = $midframe->Frame(-relief=>'sunken',-borderwidth=>5);
$midframer = $midframe->Frame(-relief=>'sunken',-borderwidth=>5);
$midframer1 = $midframer->Frame(-relief=>'sunken',-borderwidth=>5);
}
}
sub findit
{
$fm_gr2->destroy();
$midframe->destroy();
$fm_gr2 = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr2->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_gr1);
$midframe = $mw->Frame()->pack();
$c=$fm_gr2->Canvas(-width => 1400, -height =>40); 
$c->pack;
$cccc=0;
for($i=0;$i<length($seq);$i++)
{
$fko=substr($seq,$i,1);
if($fko eq "A" || $fko eq "T" || $fko eq "G" || $fko eq "C")
{
$cccc++;
}
}
$found="";
if($cccc/length($seq) == 1)
{
$found="DNA";
}
else
{
$found="PROTEIN";
}
%color=(
'EPR'=>'#FF0202','C-Terminal_1'=>'#FF02A3','C-Terminal_2'=>'#BC02FF','Zinc Finger'=>'#5F02FF','FYVE'=>'#0206FF',
'Tandem'=>'#02EFFF','Proline'=>'#02FF0B','ZBR'=>'#C5FF02','TAZ finger'=>'#FFAB02','CXXC_2F'=>'#FF6802',
'DHHC_2F'=>'#FF2802','R-TR_1'=>'#BFB1AE','ATP/GTP'=>'#4B0F38','Martin 2F'=>'#072A19','Cystine'=>'#92F696',
'Sig'=>'#000000','ARFCAP'=>'#FFFFFF','Unknown'=>'#5B0003','THAP_2F'=>'#6C620A');
$midframe->destroy();
$n=1220/length($seq);
$o=length($seq);
for($i=100;$i<1319;)
{
$c->createLine($i,35,$i+$n,35,-fill=>"green");
$i+=$n;
}
if(length($seq) > 0 && length($seq) <= 50)
{
$j=0;
$k=0;
for($i=100;$i<1320;)
{
$c->createText($i,25,-fill =>'black',-font=>[-size =>'10'],-text =>"$j");
$c->createLine($i,28,$i,40,-fill=>"red");
$i+=$n;
$j++;
}
}
elsif(length($seq) > 50 && length($seq) <= 100)
{
$j=0;
$k=0;
for($i=100;$i<1320;)
{
if($j == $k*5)
{
$c->createText($i,25,-fill =>'black',-font=>[-size =>'10'],-text =>"$j");
$c->createLine($i,28,$i,40,-fill=>"red");
$k++;
}
$i+=$n;
$j++;
}
}
elsif(length($seq) > 100 && length($seq) <= 10000)
{
$j=0;
$k=0;
for($i=100;$i<1320;)
{
if($j == $k*10)
{
$c->createText($i,25,-fill =>'black',-font=>[-size =>'10'],-text =>"$j");
$c->createLine($i,28,$i,40,-fill=>"red");
$k++;
}
$i+=$n;
$j++;
}
}
elsif(length($seq) > 10000)
{
$j=0;
$k=0;
for($i=100;$i<1320;)
{
if($j == $k*100)
{
$c->createText($i,25,-fill =>'black',-font=>[-size =>'10'],-text =>"$j");
$c->createLine($i,28,$i,40,-fill=>"red");
$k++;
}
$i+=$n;
$j++;
}
}
@motif=('EPR','C-Terminal_1','C-Terminal_2',
		'Zinc Finger','FYVE','IQ','Proline',
		'ZBR','TAZ finger','CXXC_2F','DHHC_2F',
		'R-TR_1','ATP/GTP','Martin 2F','Cystine',
		'Sig','ARFCAP','Unknown','THAP_2F',
		'Tandem');
@motifseq=('[ACDEFGHIKLNMPQRSTVWY]{2}C{1}[ACDEFGHIKNLMPQRSTVWY]{4}C{1}[ACDEFGHIKNLMPQRSTVWY]{10}H{1}G{3}',
		   'E{1}G{1}R{1}V{1}H{1}G{3}L{2}X{1}L{2}',
		   'A{1}R{1}G{1}[ACDEFGHIKLMNPQRSTVWY]{2}G{1}L{2}[ACDEFGHIKLMNPQRSTVWY]{2}H{1}',
		   'C{1}[ACDEFGHIKLNMPQRSTVWY]{2}C{1}[ACDEFGHIKLNMPQRSTVWY]{16,17}C{1}[ACDEFGHIKLNMPQRSTVWY]{2}C{2}',
		   'R{1}[RK]H{2}C{1}R{1}[ACDEFGHIKLNMPQRSTVWY]{1}C{1}G{1}',
		   'A{1}[ACDEFGHIKLNMPQRSTVWY]{3}I{1}Q{1}F{1}R{1}[ACDEFGHIKLNMPQRSTVWY]{4}K{2}',
		   '[AP]P{2}[AP]Y{2}',
		   'H{1}[ACDEFGHIKLNMPQRSTVWY]{3}H{1}[ACDEFGHIKLNMPQRSTVWY]{23}C{1}[ACDEFGHIKLNMPQRSTVWY]{2}C{1}',
		   'H{1}[ACDEFGHIKLNMPQRSTVWY]{3}C{1}[ACDEFGHIKLNMPQRSTVWY]{12}C{1}[ACDEFGHIKLNMPQRSTVWY]{4}C{1}',
		   'C{1}[ACDEFGHIKLNMPQRSTVWY]{2}C{1}[ACDEFGHIKLNMPQRSTVWY]{2}C{1}[ACDEFGHIKLNMPQRSTVWY]{5}V{1}[ACDEFGHIKLNMPQRSTVWY]{2}',
		   'A{1}H{2}C{1}',
		   'C{1}[ACDEFGHIKLNMPQRSTVWY]{4}C{1}[ACDEFGHIKLNMPQRSTVWY]{27}C{1}[ACDEFGHIKLNMPQRSTVWY]{3}[CH]{1}',
		   '[AG]{1}[ACDEFGHIKLNMPQRSTVWY]{4}[GK]{1}[ST]{1}',
		   'C{1}[ACDEFGHIKLNMPQRSTVWY]{2}C{1}[ACDEFGHIKLNMPQRSTVWY]{12,16}H{1}[ACDEFGHIKLNMPQRSTVWY]{5}H{1}',
		   'C{1}[ACDEFGHIKLNMPQRSTVWY]{2}C{1}[ACDEFGHIKLNMPQRSTVWY]{6}C{1}[ACDEFGHIKLNMPQRSTVWY]{5,12}C{1}[ACDEFGHIKLNMPQRSTVWY]{2}C{1}[ACDEFGHIKLNMPQRSTVWY]{6,8}C{1}',
		   '[FYST]{1}[ACDEFGHIKLNMPQRSTVWY]{1}[FVA]{1}',
		   'C{1}[ACDEFGHIKLNMPQRSTVWY]{2}C{1}[ACDEFGHIKLNMPQRSTVWY]{16,17}C{1}[ACDEFGHIKLNMPQRSTVWY]{2}C{1}',
		   'C{1}[ACDEFGHIKLNMPQRSTVWY]{2}C{1}[ACDEFGHIKLNMPQRSTVWY]{6}C{1}[ACDEFGHIKLNMPQRSTVWY]{3}C{1}',
		   'C{1}[ACDEFGHIKLNMPQRSTVWY]{2,4}C{1}[ACDEFGHIKLNMPQRSTVWY]{25,50}C{1}[ACDEFGHIKLNMPQRSTVWY]{2}H{1}',
		   '([ACDEFGHIKLNMPQRSTVWY]{2,}){1,}');
@motmat=();
$go=1225/length($seq);
@final1=();
@final=();
@matches=();
for($i=0;$i<scalar(@motif);$i++)
{
@pat=();
@pat=($seq=~/$motifseq[$i]/g);
for($k=0;$k<scalar(@pat);$k++)
{
$count=0;
for($j=0;$j<length($seq);)
{
if($pat[$k] eq substr($seq,$j,length($pat[$k])))
{
$count++;
push(@motmat,$j);
push(@final1,$pat[$k]);
push(@final,$motif[$i]);
$j=$j+length($pat[$k]);
}
else
{
$j++;
}
}
push(@matches,$count);
}
}
$num_channels = scalar(@final1);
######################
#dont touch
######################
$midframe = $mw->Frame()->pack();
$midframel = $midframe->Frame(-relief=>'sunken',-borderwidth=>5)->pack(-side=>'left',-expand=>1,-fill=>'y');
$midframer = $midframe->Frame(-relief=>'sunken',-borderwidth=>5)->pack(-side=>'right');
$midframer1 = $midframer->Frame(-relief=>'sunken',-borderwidth=>5)->pack(-side=>'top');
$yscroll = $midframer1->Scrollbar( 
-orient  => 'vertical',
-command => \&yscrollit,
-background=>'red'
)->pack(-side=>'right',-fill=>'y');
$canvasp = $midframer1->Canvas(-bg =>'white',-width=>1250,-height=>611,
-scrollregion=>[-10,0,7450,(33 * $num_channels)],         
-yscrollincrement => 1,         
-yscrollcommand => ['set', $yscroll ])->pack(-side=>'left');
$canvass = $midframel->Canvas(-bg =>'lightseagreen',-width=>75,-height=>611,
-scrollregion=>[-10,0,7450,(33 * $num_channels)], 
-yscrollincrement => 1)->pack(-side=>'top');
######################
#Displaying text
######################
$bef=$before->get();
$afr=$after->get();
for($i=0;$i<scalar(@final);$i++)
{
$canvass->createText(38,25+$i*33,-text=>"$final[$i]($matches[$i])",-font=>[-size =>'7']);
$canvasp->createLine(8,19+$i*33,1225,19+$i*33);
}
for($j=0;$j<scalar(@motmat);$j++)
{
@resib=();
@resia=();
$ii=length($final1[$j])-1;
$i=length($final1[$j]);
$canvasp->createRectangle(8+($go*$motmat[$j]),15+$j*33,(8+(($go*$motmat[$j])+($ii*$go))),23+$j*33,-fill=>"$color{$final[$j]}");
$canvasp->createText(8+($go*$motmat[$j]),12+$j*33,-fill => 'black',-font=>[-size =>'5'],-text =>"$motmat[$j]"); 
for($op=0;$op<$bef;$op++)
{
$resib[$op]=substr($seq,$motmat[$j]-$bef+$op,1);
}
$befmot=($motmat[$j]*$go)-($bef*$go);
for($f=0;$f<$bef;$f++)
{
$canvasp->createText(8+($befmot+($f*$go)),15+$j*33,-fill => 'black',-font=>[-size =>'10'],-text =>"$resib[$f]"); 
}
for($op=0;$op<$afr;$op++)
{
$resia[$op]=substr($seq,$motmat[$j]+$i+$op,1);
}
$afrmot=(($motmat[$j]+$i)*$go);
for($f=0;$f<$afr;$f++)
{
$canvasp->createText(8+($afrmot+($f*$go)),15+$j*33,-fill => 'black',-font=>[-size =>'10'],-text =>"$resia[$f]"); 
}
}
}
######################
#Scrolling Part
######################
sub yscrollit
{
$fraction = $_[1];
$canvass->yviewMoveto($fraction);
$canvasp->yviewMoveto($fraction);
}
}
sub mhb
{
$fm_gr->destroy();
$fm_gr1->destroy();
$fm_gr2->destroy();
$midframe->destroy();
$fm_gr = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr->pack(-side=>'top',-expand=>0,-fill=>'x');
$fm_gr1 = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr2 = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$down=$fm_gr->Button(-text=>"Upload text file",-font=>[-size =>'10'],-command=>\&upload3)->pack(-side=>"left");
$entry=$fm_gr->Entry(-width=>"40",-background=>"lightgreen")->pack(-side=>"left");
$down=$fm_gr->Button(-text=>"Match",-font=>[-size =>'10'],-command=>\&match3)->pack(-side=>"right");
$midframe = $mw->Frame();
sub upload3
{
$text4=$mw->getOpenFile();
$entry->insert('0.0',"$text4");
}
sub match3
{
if($text4 ne "")
{
$fm_gr1->destroy();
$fm_gr2->destroy();
$midframe->destroy();
$fm_gr1 = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr1->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_gr);
$fm_gr2 = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr2->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_gr1);
$c=$fm_gr2->Canvas(-width => 1400, -height =>40); 
$c->pack;
$midframe = $mw->Frame()->pack();
open(FH,"$text4");
@seqd=();
$seq="";
$i=0;
$flag=0;
while(<FH>)
{
if($_=~/^>/)
{
$flag=1;
$i++;
}
else
{
$flag=0;
}
if($flag == 0)
{
chomp($_);
$seqd[$i-1].=$_;
}
}
$max=0;
for($i=0;$i<scalar(@seqd);$i++)
{
$rty=length($seqd[$i]);
if($rty>$max)
{
$max=$rty;
$seq=$seqd[$i];
}
}
$ccc=0;
for($i=0;$i<length($seq);$i++)
{
$fko=substr($seq,$i,1);
if($fko eq "B" || $fko eq "J" || $fko eq "O" || $fko eq "U" || $fko eq "X" || $fko eq "Z")
{
$ccc++;
}
}
if($ccc == 0)
{
$fm_gr1->destroy();
$fm_gr2->destroy();
$midframe->destroy();
$fm_gr1 = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr1->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_gr);
$fm_gr2 = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr2->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_gr1);
$midframe = $mw->Frame()->pack();
$label=$fm_gr1->Label(-text=>"    Please enter the number of residues you want to display before the motifs")->pack(-anchor=>'nw',-side=>'left');
$before=$fm_gr1->Entry(-text=>"0",-width=>"40",-background=>"lightgreen")->pack(-side=>"left");
$label=$fm_gr1->Label(-text=>"    Please enter the number of residues you want to display after the motifs")->pack(-anchor=>'nw',-side=>'left');
$after=$fm_gr1->Entry(-text=>"0",-width=>"40",-background=>"lightgreen")->pack(-side=>"left");
$down=$fm_gr1->Button(-text=>"Match",-font=>[-size =>'10'],-command=>\&findit1)->pack(-side=>"right");
}
else
{
$midframe->destroy();
$rg=$fm_gr2->Label(-text =>"Please enter a valid protein sequence",-font=>[-size =>'10'])->pack(-side=>'top');
$midframe = $mw->Frame();
$midframel = $midframe->Frame(-relief=>'sunken',-borderwidth=>5);
$midframer = $midframe->Frame(-relief=>'sunken',-borderwidth=>5);
$midframer1 = $midframer->Frame(-relief=>'sunken',-borderwidth=>5);
}
}
else
{
$fm_gr1->destroy();
$fm_gr2->destroy();
$midframe->destroy();
$fm_gr2 = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr2->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_gr);
$fm_gr1 = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr1->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_gr2);
$rg=$fm_gr2->Label(-text =>"Please choose a file with a sequence",-font=>[-size =>'10'])->pack(-side=>'top');;
$midframe = $mw->Frame();
$midframel = $midframe->Frame(-relief=>'sunken',-borderwidth=>5);
$midframer = $midframe->Frame(-relief=>'sunken',-borderwidth=>5);
$midframer1 = $midframer->Frame(-relief=>'sunken',-borderwidth=>5);
}
}
sub findit1
{
$fm_gr2->destroy();
$midframe->destroy();
$fm_gr2 = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr2->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_gr1);
$midframe = $mw->Frame()->pack();
$c=$fm_gr2->Canvas(-width => 1400, -height =>40); 
$c->pack;
$cccc=0;
for($i=0;$i<length($seq);$i++)
{
$fko=substr($seq,$i,1);
if($fko eq "A" || $fko eq "T" || $fko eq "G" || $fko eq "C")
{
$cccc++;
}
}
$found="";
if($cccc/length($seq) == 1)
{
$found="DNA";
}
else
{
$found="PROTEIN";
}
%color=(
'EPR'=>'#FF0202','C-Terminal_1'=>'#FF02A3','C-Terminal_2'=>'#BC02FF','Zinc Finger'=>'#5F02FF','FYVE'=>'#0206FF',
'Tandem'=>'#02EFFF','Proline'=>'#02FF0B','ZBR'=>'#C5FF02','TAZ finger'=>'#FFAB02','CXXC_2F'=>'#FF6802',
'DHHC_2F'=>'#FF2802','R-TR_1'=>'#BFB1AE','ATP/GTP'=>'#4B0F38','Martin 2F'=>'#072A19','Cystine'=>'#92F696',
'Sig'=>'#000000','ARFCAP'=>'#FFFFFF','Unknown'=>'#5B0003','THAP_2F'=>'#6C620A');
$midframe->destroy();
$n=1220/length($seq);
$o=length($seq);
for($i=100;$i<1319;)
{
$c->createLine($i,35,$i+$n,35,-fill=>"green");
$i+=$n;
}
if(length($seq) > 0 && length($seq) <= 50)
{
$j=0;
$k=0;
for($i=100;$i<1320;)
{
$c->createText($i,25,-fill =>'black',-font=>[-size =>'10'],-text =>"$j");
$c->createLine($i,28,$i,40,-fill=>"red");
$i+=$n;
$j++;
}
}
elsif(length($seq) > 50 && length($seq) <= 100)
{
$j=0;
$k=0;
for($i=100;$i<1320;)
{
if($j == $k*5)
{
$c->createText($i,25,-fill =>'black',-font=>[-size =>'10'],-text =>"$j");
$c->createLine($i,28,$i,40,-fill=>"red");
$k++;
}
$i+=$n;
$j++;
}
}
elsif(length($seq) > 100 && length($seq) <= 10000)
{
$j=0;
$k=0;
for($i=100;$i<1320;)
{
if($j == $k*10)
{
$c->createText($i,25,-fill =>'black',-font=>[-size =>'10'],-text =>"$j");
$c->createLine($i,28,$i,40,-fill=>"red");
$k++;
}
$i+=$n;
$j++;
}
}
elsif(length($seq) > 10000)
{
$j=0;
$k=0;
for($i=100;$i<1320;)
{
if($j == $k*100)
{
$c->createText($i,25,-fill =>'black',-font=>[-size =>'10'],-text =>"$j");
$c->createLine($i,28,$i,40,-fill=>"red");
$k++;
}
$i+=$n;
$j++;
}
}
@motif=('EPR','C-Terminal_1','C-Terminal_2',
		'Zinc Finger','FYVE','IQ','Proline',
		'ZBR','TAZ finger','CXXC_2F','DHHC_2F',
		'R-TR_1','ATP/GTP','Martin 2F','Cystine',
		'Sig','ARFCAP','Unknown','THAP_2F',
		'Tandem');
@motifseq=('[ACDEFGHIKLNMPQRSTVWY]{2}C{1}[ACDEFGHIKNLMPQRSTVWY]{4}C{1}[ACDEFGHIKNLMPQRSTVWY]{10}H{1}G{3}',
		   'E{1}G{1}R{1}V{1}H{1}G{3}L{2}X{1}L{2}',
		   'A{1}R{1}G{1}[ACDEFGHIKLMNPQRSTVWY]{2}G{1}L{2}[ACDEFGHIKLMNPQRSTVWY]{2}H{1}',
		   'C{1}[ACDEFGHIKLNMPQRSTVWY]{2}C{1}[ACDEFGHIKLNMPQRSTVWY]{16,17}C{1}[ACDEFGHIKLNMPQRSTVWY]{2}C{2}',
		   'R{1}[RK]H{2}C{1}R{1}[ACDEFGHIKLNMPQRSTVWY]{1}C{1}G{1}',
		   'A{1}[ACDEFGHIKLNMPQRSTVWY]{3}I{1}Q{1}F{1}R{1}[ACDEFGHIKLNMPQRSTVWY]{4}K{2}',
		   '[AP]P{2}[AP]Y{2}',
		   'H{1}[ACDEFGHIKLNMPQRSTVWY]{3}H{1}[ACDEFGHIKLNMPQRSTVWY]{23}C{1}[ACDEFGHIKLNMPQRSTVWY]{2}C{1}',
		   'H{1}[ACDEFGHIKLNMPQRSTVWY]{3}C{1}[ACDEFGHIKLNMPQRSTVWY]{12}C{1}[ACDEFGHIKLNMPQRSTVWY]{4}C{1}',
		   'C{1}[ACDEFGHIKLNMPQRSTVWY]{2}C{1}[ACDEFGHIKLNMPQRSTVWY]{2}C{1}[ACDEFGHIKLNMPQRSTVWY]{5}V{1}[ACDEFGHIKLNMPQRSTVWY]{2}',
		   'A{1}H{2}C{1}',
		   'C{1}[ACDEFGHIKLNMPQRSTVWY]{4}C{1}[ACDEFGHIKLNMPQRSTVWY]{27}C{1}[ACDEFGHIKLNMPQRSTVWY]{3}[CH]{1}',
		   '[AG]{1}[ACDEFGHIKLNMPQRSTVWY]{4}[GK]{1}[ST]{1}',
		   'C{1}[ACDEFGHIKLNMPQRSTVWY]{2}C{1}[ACDEFGHIKLNMPQRSTVWY]{12,16}H{1}[ACDEFGHIKLNMPQRSTVWY]{5}H{1}',
		   'C{1}[ACDEFGHIKLNMPQRSTVWY]{2}C{1}[ACDEFGHIKLNMPQRSTVWY]{6}C{1}[ACDEFGHIKLNMPQRSTVWY]{5,12}C{1}[ACDEFGHIKLNMPQRSTVWY]{2}C{1}[ACDEFGHIKLNMPQRSTVWY]{6,8}C{1}',
		   '[FYST]{1}[ACDEFGHIKLNMPQRSTVWY]{1}[FVA]{1}',
		   'C{1}[ACDEFGHIKLNMPQRSTVWY]{2}C{1}[ACDEFGHIKLNMPQRSTVWY]{16,17}C{1}[ACDEFGHIKLNMPQRSTVWY]{2}C{1}',
		   'C{1}[ACDEFGHIKLNMPQRSTVWY]{2}C{1}[ACDEFGHIKLNMPQRSTVWY]{6}C{1}[ACDEFGHIKLNMPQRSTVWY]{3}C{1}',
		   'C{1}[ACDEFGHIKLNMPQRSTVWY]{2,4}C{1}[ACDEFGHIKLNMPQRSTVWY]{25,50}C{1}[ACDEFGHIKLNMPQRSTVWY]{2}H{1}',
		   '([ACDEFGHIKLNMPQRSTVWY]{2,}){1,}');
@motmat=();
$go=1225/length($seq);
@final1=();
@final=();
@sequences=();
@matches=();
for($w=0;$w<scalar(@seqd);$w++)
{
for($i=0;$i<scalar(@motif);$i++)
{
@pat=();
@pat=($seqd[$w]=~/$motifseq[$i]/g);
for($k=0;$k<scalar(@pat);$k++)
{
$count=0;
for($j=0;$j<length($seqd[$w]);)
{
if($pat[$k] eq substr($seqd[$w],$j,length($pat[$k])))
{
$count++;
push(@motmat,$j);
push(@sequences,$w+1);
push(@final1,$pat[$k]);
push(@final,$motif[$i]);
$j=$j+length($pat[$k]);
}
else
{
$j++;
}
}
push(@matches,$count);
}
}
}
$num_channels = scalar(@final1);
######################
#dont touch
######################
$midframe = $mw->Frame()->pack();
$midframel = $midframe->Frame(-relief=>'sunken',-borderwidth=>5)->pack(-side=>'left',-expand=>1,-fill=>'y');
$midframer = $midframe->Frame(-relief=>'sunken',-borderwidth=>5)->pack(-side=>'right');
$midframer1 = $midframer->Frame(-relief=>'sunken',-borderwidth=>5)->pack(-side=>'top');
$yscroll = $midframer1->Scrollbar( 
-orient  => 'vertical',
-command => \&yscrollit,
-background=>'red'
)->pack(-side=>'right',-fill=>'y');
$canvasp = $midframer1->Canvas(-bg =>'white',-width=>1250,-height=>611,
-scrollregion=>[-10,0,7450,(33 * $num_channels)],         
-yscrollincrement => 1,         
-yscrollcommand => ['set', $yscroll ])->pack(-side=>'left');
$canvass = $midframel->Canvas(-bg =>'lightseagreen',-width=>75,-height=>611,
-scrollregion=>[-10,0,7450,(33 * $num_channels)], 
-yscrollincrement => 1)->pack(-side=>'top');
######################
#Displaying text
######################
$bef=$before->get();
$afr=$after->get();
for($i=0;$i<scalar(@final);$i++)
{
$canvass->createText(38,25+$i*33,-text=>"$final[$i]"."[$sequences[$i]]"."($matches[$i])",-font=>[-size =>'7']);
$canvasp->createLine(8,19+$i*33,1225,19+$i*33);
}
for($j=0;$j<scalar(@motmat);$j++)
{
@resib=();
@resia=();
$ii=length($final1[$j])-1;
$i=length($final1[$j]);
$canvasp->createRectangle(8+($go*$motmat[$j]),15+$j*33,(8+(($go*$motmat[$j])+($ii*$go))),23+$j*33,-fill=>"$color{$final[$j]}");
$canvasp->createText(8+($go*$motmat[$j]),12+$j*33,-fill => 'black',-font=>[-size =>'5'],-text =>"$motmat[$j]"); 
for($op=0;$op<$bef;$op++)
{
$resib[$op]=substr($seq,$motmat[$j]-$bef+$op,1);
}
$befmot=($motmat[$j]*$go)-($bef*$go);
for($f=0;$f<$bef;$f++)
{
$canvasp->createText(8+($befmot+($f*$go)),15+$j*33,-fill => 'black',-font=>[-size =>'10'],-text =>"$resib[$f]"); 
}
for($op=0;$op<$afr;$op++)
{
$resia[$op]=substr($seq,$motmat[$j]+$i+$op,1);
}
$afrmot=(($motmat[$j]+$i)*$go);
for($f=0;$f<$afr;$f++)
{
$canvasp->createText(8+($afrmot+($f*$go)),15+$j*33,-fill => 'black',-font=>[-size =>'10'],-text =>"$resia[$f]"); 
}
}
}
######################
#Scrolling Part
######################
sub yscrollit
{
$fraction = $_[1];
$canvass->yviewMoveto($fraction);
$canvasp->yviewMoveto($fraction);
}
}
sub ma
{
$fm_gr->destroy();
$fm_gr1->destroy();
$fm_gr2->destroy();
$midframe->destroy();
$fm_gr = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr->pack(-side=>'top',-expand=>0,-fill=>'x');
$down=$fm_gr->Button(-text=>"Upload text file",-font=>[-size =>'10'],-command=>\&upload4)->pack(-side=>"left");
$entry=$fm_gr->Entry(-width=>"40",-background=>"lightgreen")->pack(-side=>"left");
$down=$fm_gr->Button(-text=>"Match",-font=>[-size =>'10'],-command=>\&match4)->pack(-side=>"right");
$fm_gr1 = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr2 = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$midframe = $mw->Frame();
@value=('1aa','2aa','3aa','4aa','5aa');
my $dropdownq = $fm_gr->BrowseEntry(-label => "               Select the pattern length to match",-font=>[-size =>'10'],-variable => \$dropdown_valueq)->pack(-anchor=>'nw',-side=>'left');
foreach(@value) 
{
$dropdownq->insert('end', $_);
}
sub upload4
{
$text4=$mw->getOpenFile();
$entry->insert('0.0',"$text4");
}
sub match4
{
if($text4 ne "")
{
$fm_gr1->destroy();
$fm_gr2->destroy();
$midframe->destroy();
$fm_gr2 = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr2->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_gr);
$fm_gr1 = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr1->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_gr2);
$midframe = $mw->Frame()->pack();
open(FH,"$text4");
@seqda=();
@orga=();
$seqqa="";
$i=0;
$line=1;
$flag=0;
while(<FH>)
{
if($line >= 4)
{
if($_=~/^[A-Za-z0-9]/)
{
chomp($_);
@sai=split(/\s+/,$_);
push(@orga,$sai[0]);
$seqda[$i]=$sai[1];
$i++;
}
}
$line++;
}
$maxa=0;
for($i=0;$i<scalar(@seqda);$i++)
{
$rtya=length($seqda[$i]);
if($rtya>$maxa)
{
$maxa=$rtya;
$seqqa=$seqda[$i];
}
}
$ccca=0;
for($i=0;$i<length($seqqa);$i++)
{
$fko=substr($seqqa,$i,1);
if($fko eq "B" || $fko eq "J" || $fko eq "O" || $fko eq "U" || $fko eq "X" || $fko eq "Z")
{
$ccca++;
}
}
$dd=$dropdown_valueq;
$choice=substr($dd,0,1);
if($choice ne "")
{
if($ccca >= 0)
{
$c=$fm_gr1->Canvas(-width => 1400, -height =>40); 
$c->pack;
$midframe->destroy();
$o=length($seqqa);
$n=1220/length($seqqa);
for($i=100;$i<1319;)
{
$c->createLine($i,35,$i+$n,35,-fill=>"green");
$i+=$n;
}
if(length($seqq) > 0 && length($seqq) <= 50)
{
$j=0;
$k=0;
for($i=100;$i<1320;)
{
$c->createText($i,25,-fill =>'black',-font=>[-size =>'10'],-text =>"$j");
$c->createLine($i,28,$i,40,-fill=>"red");
$i+=$n;
$j++;
}
}
elsif(length($seqq) > 50 && length($seqq) <= 100)
{
$j=0;
$k=0;
for($i=100;$i<1320;)
{
if($j == $k*5)
{
$c->createText($i,25,-fill =>'black',-font=>[-size =>'10'],-text =>"$j");
$c->createLine($i,28,$i,40,-fill=>"red");
$k++;
}
$i+=$n;
$j++;
}
}
elsif(length($seqq) > 100 && length($seqq) <= 1000)
{
$j=0;
$k=0;
for($i=100;$i<1320;)
{
if($j == $k*10)
{
$c->createText($i,25,-fill =>'black',-font=>[-size =>'10'],-text =>"$j");
$c->createLine($i,28,$i,40,-fill=>"red");
$k++;
}
$i+=$n;
$j++;
}
}
elsif(length($seqq) > 1000)
{
$j=0;
$k=0;
for($i=100;$i<1320;)
{
if($j == $k*100)
{
$c->createText($i,25,-fill =>'black',-font=>[-size =>'10'],-text =>"$j");
$c->createLine($i,28,$i,40,-fill=>"red");
$k++;
}
$i+=$n;
$j++;
}
}
@onea=();
@twoa=();
@threea=();
@foura=();
$dd=$dropdown_valueq;
$choice=substr($dd,0,1);
$rr=$choice-1;
for($i=0;$i<scalar(@seqda);$i++)
{
for($k=0;$k<length($seqda[$i])-$rr;$k++)
{
$idd1=substr($seqda[$i],$k,1);
$idd2=substr($seqda[$i],$k+1,1);
if(($idd1 ne "-") && ($idd2 ne "-"))
{
$fhj=substr($seqda[$i],$k,$choice);
$onea[$i][$k]=$fhj;
}
}
}
$df=$onea[0][0];
$twoa[0][0]=$df;
for($i=0;$i<scalar(@onea);$i++)
{
for($j=0;$j<=$#{$onea[$i]} ;$j++)
{
$count=0;
for($k=0;$k<=$#{$twoa[$i]};$k++)
{
if($onea[$i][$j] eq $twoa[$i][$k])
{
$count++;
}
}
if($count == 0)
{
$twoa[$i][$k]=$onea[$i][$j];
}
}
}
$ddf=$twoa[0][0];
push(@threea,$ddf);
for($i=0;$i<scalar(@twoa);$i++)
{
for($j=0;$j<=$#{$twoa[$i]} ;$j++)
{
$count=0;
for($k=0;$k<scalar(@threea);$k++)
{
if($twoa[$i][$j] eq $threea[$k])
{
$count++;
}
}
if($count == 0)
{
$ddfff=$twoa[$i][$j];
push(@threea,$ddfff);
}
}
}
%colo1r=(
'A'=>'#FF0202','R'=>'#FF02A3','N'=>'#BC02FF','D'=>'#5F02FF','C'=>'#0206FF','E'=>'#02EFFF',
'Q'=>'#02FF0B','G'=>'#C5FF02','H'=>'#FFAB02','I'=>'#FF6802','L'=>'#FF2802','K'=>'#BFB1AE',
'M'=>'#4B0F38','F'=>'#072A19','P'=>'#92F696','S'=>'#000000','T'=>'#FFFFFF','W'=>'#5B0003',
'Y'=>'#6C620A','V'=>'#151B54');
$go=1225/length($seqqa);
@matchesa=();
for($i=0;$i<scalar(@threea);$i++)
{
for($j=0;$j<scalar(@seqda);$j++)
{
$count=0;
for($k=0;$k<length($seqda[$j]);$k++)
{
$fgh=substr($seqda[$j],$k,$choice);
if($fgh eq $threea[$i])
{
$count++;
}
}
push(@matchesa,$count);
}
}
$num_channels = scalar(@threea)*scalar(@seqda);
######################
#dont touch
######################
$midframe = $mw->Frame()->pack();
$midframel = $midframe->Frame(-relief=>'sunken',-borderwidth=>5)->pack(-side=>'left',-expand=>1,-fill=>'y');
$midframer = $midframe->Frame(-relief=>'sunken',-borderwidth=>5)->pack(-side=>'right');
$midframer1 = $midframer->Frame(-relief=>'sunken',-borderwidth=>5)->pack(-side=>'top');
$yscroll = $midframer1->Scrollbar( 
-orient  => 'vertical',
-command => \&yscrollit,
-background=>'red'
)->pack(-side=>'right',-fill=>'y');
$canvasp = $midframer1->Canvas(-bg =>'white',-width=>1250,-height=>611,
-scrollregion=>[-10,0,7450,(33 * $num_channels)],         
-yscrollincrement => 1,         
-yscrollcommand => ['set', $yscroll ])->pack(-side=>'left');
$canvass = $midframel->Canvas(-bg =>'lightseagreen',-width=>75,-height=>611,
-scrollregion=>[-10,0,7450,(33 * $num_channels)], 
-yscrollincrement => 1)->pack(-side=>'top');
######################
#Displaying text
######################
$k=0;
for($i=0;$i<scalar(@threea);$i++)
{
for($j=0;$j<scalar(@seqda);$j++)
{
$canvass->createText(38,25+$k*33,-text=>"$threea[$i]"."[$orga[$j]]"."($matchesa[$k])",-font=>[-size =>'7']);
$canvasp->createLine(8,19+$k*33,1225,19+$k*33);
$k++;
}
}
$rv=0;
for($i=0;$i<scalar(@threea);$i++)
{
for($j=0;$j<scalar(@seqda);$j++)
{
for($k=0;$k<length($seqda[$j]);$k++)
{
$fgl=substr($seqda[$j],$k,$choice);
if($fgl eq $threea[$i])
{
$lk=$rr;
for($p=$choice;$p!=0;$p--)
{
$ghi=substr($fgl,$lk,1);
$lk--;
$canvasp->createRectangle(8+($go*$k),15+$rv*33,8+($go*$p)+($go*$k),23+$rv*33,-fill=>"$colo1r{$ghi}");
}
$canvasp->createText(8+($go*$k),12+$rv*33,-fill => 'black',-font=>[-size =>'5'],-text =>$k); 
}
}
$rv++;
}
}
}
else
{
$midframe->destroy();
$rg=$fm_gr2->Label(-text =>"Please enter a valid protein sequence",-font=>[-size =>'10'])->pack(-side=>'top');;
$midframe = $mw->Frame();
$midframel = $midframe->Frame(-relief=>'sunken',-borderwidth=>5);
$midframer = $midframe->Frame(-relief=>'sunken',-borderwidth=>5);
$midframer1 = $midframer->Frame(-relief=>'sunken',-borderwidth=>5);
}
}
else
{
$midframe->destroy();
$rg=$fm_gr2->Label(-text =>"Please choose the amino acid range",-font=>[-size =>'10'])->pack(-side=>'top');;
$midframe = $mw->Frame();
$midframel = $midframe->Frame(-relief=>'sunken',-borderwidth=>5);
$midframer = $midframe->Frame(-relief=>'sunken',-borderwidth=>5);
$midframer1 = $midframer->Frame(-relief=>'sunken',-borderwidth=>5);
}
}
else
{
$fm_gr1->destroy();
$fm_gr2->destroy();
$midframe->destroy();
$fm_gr2 = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr2->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_gr);
$fm_gr1 = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr1->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_gr2);
$rg=$fm_gr2->Label(-text =>"Please select a file with a sequence",-font=>[-size =>'10'])->pack(-side=>'top');;
$midframe = $mw->Frame();
$midframel = $midframe->Frame(-relief=>'sunken',-borderwidth=>5);
$midframer = $midframe->Frame(-relief=>'sunken',-borderwidth=>5);
$midframer1 = $midframer->Frame(-relief=>'sunken',-borderwidth=>5);
}
}
######################
#Scrolling Part
######################
sub yscrollit
{
$fraction = $_[1];
$canvass->yviewMoveto($fraction);
$canvasp->yviewMoveto($fraction);
}
}
sub profs
{
@pro=();
@cho=();
$ith=1;
$fm_gr->destroy();
$fm_gr1->destroy();
$fm_gr2->destroy();
$midframe->destroy();
$fm_gr = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr->pack(-side=>'top',-expand=>0,-fill=>'x');
$fm_gr1 = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr2 = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$midframe = $mw->Frame();
$down=$fm_gr->Button(-text=>"  Upload text file  ",-font=>[-size =>'10'],-command=>\&sub1)->pack(-side=>"left");
$entry=$fm_gr->Entry(-width=>"40",-background=>"lightgreen")->pack(-side=>"left");
$down=$fm_gr->Button(-text=>"  Enter the patterns  ",-font=>[-size =>'10'],-command=>\&sub2)->pack(-side=>"right");
MainLoop;
sub sub1
{
$file=$mw->getOpenFile();
$entry->insert('0.0',"$file");
}
sub sub2
{
$fm_gr1->destroy();
$fm_gr2->destroy();
$midframe->destroy();
$fm_gr1 = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr1->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_gr);
$fm_gr2 = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr2->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_gr1);
$midframe = $mw->Frame();
$label = $fm_gr1->Label(-text=>"Enter the 1 prosite pattern  ",-font=>[-size =>'10'])->pack(-side=>'left');
$entry=$fm_gr1->Entry(-width=>"50",-background=>"lightgreen")->pack(-side=>"left");
$p2="";
$s2=$fm_gr1->Radiobutton(-text=>"ADD",-value=>"&&",-variable=>\$p2,-command=>sub{$c2=$p2; sub3($c2)},-font=>[-size =>'10'])->pack(-side=>'left');
$down=$fm_gr1->Button(-text=>"  Display  ",-font=>[-size =>'10'],-command=>\&sub4)->pack(-side=>"right");  
}
sub sub3
{
$ith++;
$seq=$entry->get();
push(@pro,$seq);
$fm_gr1->destroy();
$fm_gr2->destroy();
$midframe->destroy();
$fm_gr1 = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr1->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_gr);
$fm_gr2 = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr2->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_gr1);
$midframe = $mw->Frame();
$label = $fm_gr1->Label(-text=>"Enter the $ith prosite pattern  ",-font=>[-size =>'10'])->pack(-side=>'left');
$entry=$fm_gr1->Entry(-width=>"50",-background=>"lightgreen")->pack(-side=>"left");
$p1="";
$s2=$fm_gr1->Radiobutton(-text=>"ADD",-value=>"&&",-variable=>\$p1,-command=>sub{$c2=$p1; sub3($c2)},-font=>[-size =>'10'])->pack(-side=>'left');
$down=$fm_gr1->Button(-text=>"  Display  ",-font=>[-size =>'10'],-command=>\&sub4)->pack(-side=>"right");  
}
sub sub4
{
$seq1=$entry->get();
$midframe->destroy();
$midframe = $mw->Frame()->pack();
$midframel = $midframe->Frame(-relief=>'sunken',-borderwidth=>5)->pack(-side=>'left',-expand=>1,-fill=>'y');
$midframer = $midframe->Frame(-relief=>'sunken',-borderwidth=>5)->pack(-side=>'right');
$midframer1 = $midframer->Frame(-relief=>'sunken',-borderwidth=>5)->pack(-side=>'top');
push(@pro,$seq1);
if($file ne "" && scalar(@pro) > 0)
{



open(FW,"$file");
$seq="";
$flag=0;
while(<FW>)
{
if($_=~/^>/)
{
$flag=1;
}
else
{
$flag=0;
}
if($flag == 0)
{
chomp($_);
$seq.=$_;
}
}
$ccc=0;
for($i=0;$i<length($seq);$i++)
{
$fko=substr($seq,$i,1);
if($fko eq "B" || $fko eq "J" || $fko eq "O" || $fko eq "U" || $fko eq "X" || $fko eq "Z")
{
$ccc++;
}
}
if($ccc == 0)
{
$fm_gr2->destroy();
$midframe->destroy();
$fm_gr2 = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr2->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_gr1);
$midframe = $mw->Frame()->pack();
$c=$fm_gr2->Canvas(-width => 1400, -height =>40); 
$c->pack;
$cccc=0;
for($i=0;$i<length($seq);$i++)
{
$fko=substr($seq,$i,1);
if($fko eq "A" || $fko eq "T" || $fko eq "G" || $fko eq "C")
{
$cccc++;
}
}
$found="";
if($cccc/length($seq) == 1)
{
$found="DNA";
}
else
{
$found="PROTEIN";
}
$midframe->destroy();
$n=1220/length($seq);
$o=length($seq);
for($i=100;$i<1319;)
{
$c->createLine($i,35,$i+$n,35,-fill=>"green");
$i+=$n;
}
if(length($seq) > 0 && length($seq) <= 50)
{
$j=0;
$k=0;
for($i=100;$i<1320;)
{
$c->createText($i,25,-fill =>'black',-font=>[-size =>'10'],-text =>"$j");
$c->createLine($i,28,$i,40,-fill=>"red");
$i+=$n;
$j++;
}
}
elsif(length($seq) > 50 && length($seq) <= 100)
{
$j=0;
$k=0;
for($i=100;$i<1320;)
{
if($j == $k*5)
{
$c->createText($i,25,-fill =>'black',-font=>[-size =>'10'],-text =>"$j");
$c->createLine($i,28,$i,40,-fill=>"red");
$k++;
}
$i+=$n;
$j++;
}
}
elsif(length($seq) > 100 && length($seq) <= 10000)
{
$j=0;
$k=0;
for($i=100;$i<1320;)
{
if($j == $k*10)
{
$c->createText($i,25,-fill =>'black',-font=>[-size =>'10'],-text =>"$j");
$c->createLine($i,28,$i,40,-fill=>"red");
$k++;
}
$i+=$n;
$j++;
}
}
elsif(length($seq) > 10000)
{
$j=0;
$k=0;
for($i=100;$i<1320;)
{
if($j == $k*100)
{
$c->createText($i,25,-fill =>'black',-font=>[-size =>'10'],-text =>"$j");
$c->createLine($i,28,$i,40,-fill=>"red");
$k++;
}
$i+=$n;
$j++;
}
}
@motmat=();
$go=1225/length($seq);
@final1=();
@final=();
@matches=();
for($i=0;$i<scalar(@pro);$i++)
{
@pat=();
@pat=($seq=~/$pro[$i]/g);
for($k=0;$k<scalar(@pat);$k++)
{
$count=0;
for($j=0;$j<length($seq);)
{
if($pat[$k] eq substr($seq,$j,length($pat[$k])))
{
$count++;
push(@motmat,$j);
push(@final1,$pat[$k]);
$macheee=$i+1;
push(@final,"Pattern $macheee");
$j=$j+length($pat[$k]);
}
else
{
$j++;
}
}
push(@matches,$count);
}
}
$num_channels = scalar(@final1);
######################
#dont touch
######################
$midframe = $mw->Frame()->pack();
$midframel = $midframe->Frame(-relief=>'sunken',-borderwidth=>5)->pack(-side=>'left',-expand=>1,-fill=>'y');
$midframer = $midframe->Frame(-relief=>'sunken',-borderwidth=>5)->pack(-side=>'right');
$midframer1 = $midframer->Frame(-relief=>'sunken',-borderwidth=>5)->pack(-side=>'top');
$yscroll = $midframer1->Scrollbar( 
-orient  => 'vertical',
-command => \&yscrollit,
-background=>'red'
)->pack(-side=>'right',-fill=>'y');
$canvasp = $midframer1->Canvas(-bg =>'white',-width=>1250,-height=>611,
-scrollregion=>[-10,0,7450,(33 * $num_channels)],         
-yscrollincrement => 1,         
-yscrollcommand => ['set', $yscroll ])->pack(-side=>'left');
$canvass = $midframel->Canvas(-bg =>'lightseagreen',-width=>75,-height=>611,
-scrollregion=>[-10,0,7450,(33 * $num_channels)], 
-yscrollincrement => 1)->pack(-side=>'top');
######################
#Displaying text
######################
$bef=0;
$afr=0;
for($i=0;$i<scalar(@final);$i++)
{
$canvass->createText(38,25+$i*33,-text=>"$final[$i]($matches[$i])",-font=>[-size =>'7']);
$canvasp->createLine(8,19+$i*33,1225,19+$i*33);
}
$mw2=MainWindow->new(-title=>'Pattern Key');
$fm_gr2w = $mw2->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr2w->pack(-side=>'top',-expand=>0,-fill=>'x');
$displaykey="";
$displaykey.="The entered Prosite patterns\n\n\n";
for($lolo=0;$lolo<scalar(@pro);$lolo++)
{
$gogogo=$lolo+1;
$displaykey.="Prosite pattern $gogogo: $pro[$lolo]\n\n";
}
$displaykey.="\nThe obtained patterns and their positions\n\n\n";
for($lolo=0;$lolo<scalar(@final1);$lolo++)
{
$gogogo=$lolo+1;
$displaykey.="Pattern $gogogo: $final1[$lolo] at position $motmat[$lolo]\n\n";
}
$l1=$fm_gr2w->Label(-text=>"$displaykey",-font=>[-size=>"10",-weight =>'bold'])->pack(-side=>'left');
for($j=0;$j<scalar(@motmat);$j++)
{
@resib=();
@resia=();
$ii=length($final1[$j])-1;
$i=length($final1[$j]);
$canvasp->createRectangle(8+($go*$motmat[$j]),15+$j*33,(8+(($go*$motmat[$j])+($ii*$go))),23+$j*33,-fill=>"black");
$canvasp->createText(8+($go*$motmat[$j]),12+$j*33,-fill => 'black',-font=>[-size =>'5'],-text =>"$motmat[$j]"); 
}
}
}
else
{
$fm_gr2->destroy();
$fm_gr2 = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr2->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_gr1);
$label = $fm_gr2->Label(-text=>"The necessary information is not provided",-font=>[-size =>'10'])->pack(-side=>'top');
}
}
}
sub seqa
{

}