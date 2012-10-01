#!/usr/bin/perl -w

# config-part
my $shell="aterm";

=pod

=head1 NAME

    ordner.pl - ordner is the german word for folder.

=head1 DESCRIPTION

    shows all the folders and files of an chosen folder.
    It has two sections (two little filemanagers). It's just under Development, so
    I don't know the features coming in future.

=head1 BUGS

    no bugs known

=head1 THANKS

    thanks to all people using this script. Also thanks to the
    team of gtk2-perl for the great documentation.

=head1 COPYRIGHT

    Copyright (C) Joel Fridolin Meyer 2012

=head1 AVAILABILITY

    newer versions and documentation here: http://github.com/sirjofri/ordner

=head1 AUTHOR

    Joel Fridolin Meyer (sirjofri)

=head1 WHEN YOU FIND BUGS ...

    you should write me an email: I<sirjofri (at) gmx (dot) de>
    Thanks

=head1 RIGHTS

    This program is opensource. Do with it what you want.

=cut

use strict;
use warnings;
use Glib;
use Gtk2 '-init';
use Cwd;

my $pwd=cwd();

my @content_left;
my @content_right;

my $window=Gtk2::Window->new;
my $vbox_gesamt=Gtk2::VBox->new;
my $vbox_left=Gtk2::VBox->new;
my $hbox_opener_left=Gtk2::HBox->new;
my $hbox_opener_right=Gtk2::HBox->new;
my $paned=Gtk2::HPaned->new;
my $vbox_right=Gtk2::VBox->new;
my $entry_left=Gtk2::Entry->new;
$entry_left->set_text("/");
my $entry_right=Gtk2::Entry->new;
$entry_right->set_text("$pwd/");
my $button_go_left=Gtk2::Button->new("Go");
my $button_go_right=Gtk2::Button->new("Go");
my $button_go_from_left=Gtk2::Button->new("Go from List");
my $button_go_from_right=Gtk2::Button->new("Go from List");
my $box=Gtk2::HBox->new;
my $leftsw=Gtk2::ScrolledWindow->new;
my $rightsw=Gtk2::ScrolledWindow->new;
my $list_left=Gtk2::ListStore->new("Glib::String");
my $view_left=Gtk2::TreeView->new_with_model($list_left);
my $list_right=Gtk2::ListStore->new("Glib::String");
my $view_right=Gtk2::TreeView->new_with_model($list_right);
my $head=Gtk2::Label->new;
my $foot=Gtk2::Label->new;
$head->set_text("This program is just under development");
$foot->set_text("Copyright (C) Joel Fridolin Meyer 2012");
my $actions_left=Gtk2::HBox->new;
my $action_left_editor=Gtk2::Button->new("edit");
my $action_left_shell=Gtk2::Button->new("shell");
my $action_left_exec=Gtk2::Button->new("exec");
my $actions_right=Gtk2::HBox->new;
my $action_right_editor=Gtk2::Button->new("edit");
my $action_right_shell=Gtk2::Button->new("shell");
my $action_right_exec=Gtk2::Button->new("exec");

$view_right->set_headers_visible(0);
$view_right->insert_column_with_attributes(0,"Name",Gtk2::CellRendererText->new,text=>0);

$view_left->set_headers_visible(0);
$view_left->insert_column_with_attributes(0,"Name",Gtk2::CellRendererText->new,text=>0);

$leftsw->add_with_viewport($view_left);
$rightsw->add_with_viewport($view_right);
$hbox_opener_left->pack_start($entry_left,1,1,0);
$hbox_opener_left->pack_start($button_go_left,0,1,0);
$actions_left->pack_start($action_left_editor,0,1,1);
$actions_left->pack_start($action_left_shell,0,1,1);
$actions_left->pack_start($action_left_exec,0,1,1);
$vbox_left->pack_start($hbox_opener_left,0,1,1);
$vbox_left->pack_start($button_go_from_left,0,1,1);
$vbox_left->pack_start($leftsw,1,1,1);
$vbox_left->pack_start($actions_left,0,1,1);
$hbox_opener_right->pack_start($entry_right,1,1,0);
$hbox_opener_right->pack_start($button_go_right,0,1,0);
$actions_right->pack_start($action_right_editor,0,1,1);
$actions_right->pack_start($action_right_shell,0,1,1);
$actions_right->pack_start($action_right_exec,0,1,1);
$vbox_right->pack_start($hbox_opener_right,0,1,1);
$vbox_right->pack_start($button_go_from_right,0,1,1);
$vbox_right->pack_start($rightsw,1,1,1);
$vbox_right->pack_start($actions_right,0,1,1);
$paned->add1($vbox_left);
$paned->add2($vbox_right);
$vbox_gesamt->pack_start($head,0,1,1);
$vbox_gesamt->pack_start($paned,1,1,1);
$vbox_gesamt->pack_start($foot,0,1,1);
$box->pack_start($vbox_gesamt,1,1,1);
$window->add($box);
$window->set_title("Ordner");
$window->set_default_size(400,300);
$window->show_all;
$window->signal_connect(destroy=>\&schluss);

$button_go_left->signal_connect(clicked=>\&go_left);
$button_go_right->signal_connect(clicked=>\&go_right);

$button_go_from_left->signal_connect(clicked=>\&go_from_left);
$button_go_from_right->signal_connect(clicked=>\&go_from_right);

$action_left_editor->signal_connect(clicked=>\&open_editor_left);
$action_left_shell->signal_connect(clicked=>\&open_shell_left);
$action_left_exec->signal_connect(clicked=>\&execute_left);

$action_right_editor->signal_connect(clicked=>\&open_editor_right);
$action_right_shell->signal_connect(clicked=>\&open_shell_right);
$action_right_exec->signal_connect(clicked=>\&execute_right);

sub open_editor_left
{
	my $path=$entry_left->get_text;
	my $editor=$ENV{"EDITOR"};
	my $file="$path/";
	my $selection=$view_left->get_selection;
	$selection->selected_foreach(sub{
		my ($model,$path,$iter)=@_;
		my $filename=$model->get($iter,0);
		$file.="$filename";
	});
	my $execut="$editor $file";
	print "$execut\n";
	system("$execut");
}

sub open_shell_left
{
	my $path=$entry_left->get_text;
	system("$shell -e sh");
}

sub execute_left
{
	my $path=$entry_left->get_text;
	my $file="$path/";
	my $selection=$view_left->get_selection;
	$selection->selected_foreach(sub{
		my ($model,$path,$iter)=@_;
		my $filename=$model->get($iter,0);
		$file.="$filename";
	});
	system("$shell -c $file");
}

sub open_editor_right
{
	my $path=$entry_right->get_text;
	my $editor=$ENV{"EDITOR"};
	my $file="$path/";
	my $selection=$view_right->get_selection;
	$selection->selected_foreach(sub{
		my ($model,$path,$iter)=@_;
		my $filename=$model->get($iter,0);
		$file.="$filename";
	});
	my $execut="$editor $file";
	print "$execut\n";
	system("$execut");
}

sub open_shell_right
{
	my $path=$entry_right->get_text;
	system("aterm -e sh");
}

sub execute_right
{
	my $path=$entry_right->get_text;
	my $file="$path/";
	my $selection=$view_right->get_selection;
	$selection->selected_foreach(sub{
		my ($model,$path,$iter)=@_;
		my $filename=$model->get($iter,0);
		$file.="$filename";
	});
	system("$shell -e $file");
}

sub go_from_left
{
	my $wherefrom=$entry_left->get_text;
	my $towhere=$wherefrom;
	my $selection=$view_left->get_selection;
	$selection->selected_foreach(sub{
		my ($model,$path,$iter)=@_;
		my $value=$model->get($iter,0);
		if($value eq "..")
		{
			chop($towhere);
			$towhere.="()";
			$towhere=~s/\/[a-zA-Z0-9\ \-\.]+\(\)//;
			$value="";
		}
		if($value eq ".")
		{
			chop($towhere);
			$value="";
		}
		$towhere.="$value/";
		$entry_left->set_text($towhere);
		print "value: $value\ntowhere: $towhere\n";
		&go_left;
	});
}

sub go_from_right
{
	my $wherefrom=$entry_right->get_text;
	my $towhere=$wherefrom;
	my $selection=$view_right->get_selection;
	$selection->selected_foreach(sub{
		my ($model,$path,$iter)=@_;
		my $value=$model->get($iter,0);
		if($value eq "..")
		{
			chop($towhere);
			$towhere.="()";
			$towhere=~s/\/[a-zA-Z0-9\ \-\.]+\(\)//;
			$value="";
		}
		if($value eq ".")
		{
			chop($towhere);
			$value="";
		}
		$towhere.="$value/";
		$entry_right->set_text($towhere);
		print "value: $value\ntowhere: $towhere\n";
		&go_right;
	});
}

&go_left;
&go_right;

sub go_left
{
	@content_left=read_folder($entry_left->get_text);
	$list_left->clear;
	my $content_length_left=@content_left;
	for(my $i=0;$i<$content_length_left;$i++)
	{
		my $iter=$list_left->append();
		$list_left->set($iter,0,"$content_left[$i]");
#		print "$content_left[$i]\n";
	}
}
sub go_right
{
	@content_right=read_folder($entry_right->get_text);
	$list_right->clear;
	my $content_length_right=@content_right;
	for(my $i=0;$i<$content_length_right;$i++)
	{
		my $iter=$list_right->append();
		$list_right->set($iter,0,"$content_right[$i]");
#		print "$content_left[$i]\n";
	}
}

sub read_folder
{
	my $folder=$_[0];
	opendir(FD,$folder) or die $!;
	my @content=readdir(FD);
	close(FD);
	return @content;
}

sub schluss
{
	Gtk2->main_quit;
	exit(0);
}

Gtk2->main;
