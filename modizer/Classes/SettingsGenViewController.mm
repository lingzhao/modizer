//
//  SettingsGenViewController.m
//  modizer
//
//  Created by Yohann Magnien on 10/08/13.
//
//

#import "SettingsGenViewController.h"
#import "MNEValueTrackingSlider.h"

#import "Reachability.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <sys/xattr.h>


@interface SettingsGenViewController ()
@end

@implementation SettingsGenViewController

@synthesize tableView,detailViewController;

volatile t_settings settings[MAX_SETTINGS];

-(IBAction) goPlayer {
	[self.navigationController pushViewController:detailViewController animated:(detailViewController.mSlowDevice?NO:YES)];
}

#pragma mark - Callback methods

void optFTPSwitchChanged(id param) {
    [param FTPswitchChanged];
}


-(void) optGLOBALChanged {
    [detailViewController settingsChanged:(int)SETTINGS_GLOBAL];
}
void optGLOBALChangedC(id param) {
    [param optGLOBALChanged];
}

#pragma mark - Load/Init default settings

+ (void) loadSettings {
    memset((char*)settings,0,sizeof(settings));
    /////////////////////////////////////
    //ROOT
    /////////////////////////////////////
    settings[MDZ_SETTINGS_FAMILY_GLOBAL_PLAYER].type=MDZ_FAMILY;
    settings[MDZ_SETTINGS_FAMILY_GLOBAL_PLAYER].label=(char*)"Global";
    settings[MDZ_SETTINGS_FAMILY_GLOBAL_PLAYER].description=NULL;
    settings[MDZ_SETTINGS_FAMILY_GLOBAL_PLAYER].family=MDZ_SETTINGS_ROOT;
    settings[MDZ_SETTINGS_FAMILY_GLOBAL_PLAYER].sub_family=MDZ_SETTINGS_GLOBAL_PLAYER;
    
    settings[MDZ_SETTINGS_FAMILY_GLOBAL_VISU].type=MDZ_FAMILY;
    settings[MDZ_SETTINGS_FAMILY_GLOBAL_VISU].label=(char*)"Visualizers";
    settings[MDZ_SETTINGS_FAMILY_GLOBAL_VISU].description=NULL;
    settings[MDZ_SETTINGS_FAMILY_GLOBAL_VISU].family=MDZ_SETTINGS_ROOT;
    settings[MDZ_SETTINGS_FAMILY_GLOBAL_VISU].sub_family=MDZ_SETTINGS_GLOBAL_VISU;
    
    settings[MDZ_SETTINGS_FAMILY_PLUGINS].type=MDZ_FAMILY;
    settings[MDZ_SETTINGS_FAMILY_PLUGINS].label=(char*)"Plugins";
    settings[MDZ_SETTINGS_FAMILY_PLUGINS].description=NULL;
    settings[MDZ_SETTINGS_FAMILY_PLUGINS].family=MDZ_SETTINGS_ROOT;
    settings[MDZ_SETTINGS_FAMILY_PLUGINS].sub_family=MDZ_SETTINGS_PLUGINS;
    
    settings[MDZ_SETTINGS_FAMILY_GLOBAL_FTP].type=MDZ_FAMILY;
    settings[MDZ_SETTINGS_FAMILY_GLOBAL_FTP].label=(char*)"FTP";
    settings[MDZ_SETTINGS_FAMILY_GLOBAL_FTP].description=NULL;
    settings[MDZ_SETTINGS_FAMILY_GLOBAL_FTP].family=MDZ_SETTINGS_ROOT;
    settings[MDZ_SETTINGS_FAMILY_GLOBAL_FTP].sub_family=MDZ_SETTINGS_GLOBAL_FTP;
    
    
    
    /////////////////////////////////////
    //GLOBAL Player
    /////////////////////////////////////
    settings[GLOB_ForceMono].label=(char*)"Force Mono";
    settings[GLOB_ForceMono].description=NULL;
    settings[GLOB_ForceMono].family=MDZ_SETTINGS_GLOBAL_PLAYER;
    settings[GLOB_ForceMono].sub_family=0;
    settings[GLOB_ForceMono].callback=&optGLOBALChangedC;
    settings[GLOB_ForceMono].type=MDZ_BOOLSWITCH;
    settings[GLOB_ForceMono].detail.mdz_boolswitch.switch_value=1;
    
    settings[GLOB_Panning].label=(char*)"Panning";
    settings[GLOB_Panning].description=NULL;
    settings[GLOB_Panning].family=MDZ_SETTINGS_GLOBAL_PLAYER;
    settings[GLOB_Panning].sub_family=0;
    settings[GLOB_Panning].type=MDZ_BOOLSWITCH;
    settings[GLOB_Panning].detail.mdz_boolswitch.switch_value=1;
    
    settings[GLOB_PanningValue].label=(char*)"Panning Value";
    settings[GLOB_PanningValue].description=NULL;
    settings[GLOB_PanningValue].family=MDZ_SETTINGS_GLOBAL_PLAYER;
    settings[GLOB_PanningValue].sub_family=0;
    settings[GLOB_PanningValue].type=MDZ_SLIDER_CONTINUOUS;
    settings[GLOB_PanningValue].detail.mdz_slider.slider_value=0.7;
    settings[GLOB_PanningValue].detail.mdz_slider.slider_min_value=0;
    settings[GLOB_PanningValue].detail.mdz_slider.slider_max_value=1;
    
    
    settings[GLOB_DefaultLength].label=(char*)"Default Length";
    settings[GLOB_DefaultLength].description=NULL;
    settings[GLOB_DefaultLength].family=MDZ_SETTINGS_GLOBAL_PLAYER;
    settings[GLOB_DefaultLength].sub_family=0;
    settings[GLOB_DefaultLength].type=MDZ_SLIDER_DISCRETE;
    settings[GLOB_DefaultLength].detail.mdz_slider.slider_value=SONG_DEFAULT_LENGTH/1000;
    settings[GLOB_DefaultLength].detail.mdz_slider.slider_min_value=10;
    settings[GLOB_DefaultLength].detail.mdz_slider.slider_max_value=1200;
    
    settings[GLOB_DefaultMODPlayer].type=MDZ_SWITCH;
    settings[GLOB_DefaultMODPlayer].label=(char*)"Default mod player";
    settings[GLOB_DefaultMODPlayer].description=NULL;
    settings[GLOB_DefaultMODPlayer].family=MDZ_SETTINGS_GLOBAL_PLAYER;
    settings[GLOB_DefaultMODPlayer].sub_family=0;
    settings[GLOB_DefaultMODPlayer].detail.mdz_switch.switch_value=0;
    settings[GLOB_DefaultMODPlayer].detail.mdz_switch.switch_value_nb=3;
    settings[GLOB_DefaultMODPlayer].detail.mdz_switch.switch_labels=(char**)malloc(settings[GLOB_DefaultMODPlayer].detail.mdz_switch.switch_value_nb*sizeof(char*));
    settings[GLOB_DefaultMODPlayer].detail.mdz_switch.switch_labels[0]=(char*)"MDPLG";
    settings[GLOB_DefaultMODPlayer].detail.mdz_switch.switch_labels[1]=(char*)"DUMB";
    settings[GLOB_DefaultMODPlayer].detail.mdz_switch.switch_labels[2]=(char*)"UADE";
    
    settings[GLOB_TitleFilename].label=(char*)"Filename as title";
    settings[GLOB_TitleFilename].description=NULL;
    settings[GLOB_TitleFilename].family=MDZ_SETTINGS_GLOBAL_PLAYER;
    settings[GLOB_TitleFilename].sub_family=0;
    settings[GLOB_TitleFilename].type=MDZ_BOOLSWITCH;
    settings[GLOB_TitleFilename].detail.mdz_boolswitch.switch_value=0;
    
    settings[GLOB_StatsUpload].label=(char*)"Send statistics";
    settings[GLOB_StatsUpload].description=NULL;
    settings[GLOB_StatsUpload].family=MDZ_SETTINGS_GLOBAL_PLAYER;
    settings[GLOB_StatsUpload].sub_family=0;
    settings[GLOB_StatsUpload].type=MDZ_BOOLSWITCH;
    settings[GLOB_StatsUpload].detail.mdz_boolswitch.switch_value=1;
    
    settings[GLOB_BackgroundMode].type=MDZ_SWITCH;
    settings[GLOB_BackgroundMode].label=(char*)"Background mode";
    settings[GLOB_BackgroundMode].description=NULL;
    settings[GLOB_BackgroundMode].family=MDZ_SETTINGS_GLOBAL_PLAYER;
    settings[GLOB_BackgroundMode].sub_family=0;
    settings[GLOB_BackgroundMode].detail.mdz_switch.switch_value=1;
    settings[GLOB_BackgroundMode].detail.mdz_switch.switch_value_nb=3;
    settings[GLOB_BackgroundMode].detail.mdz_switch.switch_labels=(char**)malloc(settings[GLOB_BackgroundMode].detail.mdz_switch.switch_value_nb*sizeof(char*));
    settings[GLOB_BackgroundMode].detail.mdz_switch.switch_labels[0]=(char*)"Off";
    settings[GLOB_BackgroundMode].detail.mdz_switch.switch_labels[1]=(char*)"Play";
    settings[GLOB_BackgroundMode].detail.mdz_switch.switch_labels[2]=(char*)"Full";
    
    settings[GLOB_EnqueueMode].type=MDZ_SWITCH;
    settings[GLOB_EnqueueMode].label=(char*)"Enqueue mode";
    settings[GLOB_EnqueueMode].description=NULL;
    settings[GLOB_EnqueueMode].family=MDZ_SETTINGS_GLOBAL_PLAYER;
    settings[GLOB_EnqueueMode].sub_family=0;
    settings[GLOB_EnqueueMode].detail.mdz_switch.switch_value=2;
    settings[GLOB_EnqueueMode].detail.mdz_switch.switch_value_nb=3;
    settings[GLOB_EnqueueMode].detail.mdz_switch.switch_labels=(char**)malloc(settings[GLOB_EnqueueMode].detail.mdz_switch.switch_value_nb*sizeof(char*));
    settings[GLOB_EnqueueMode].detail.mdz_switch.switch_labels[0]=(char*)"First";
    settings[GLOB_EnqueueMode].detail.mdz_switch.switch_labels[1]=(char*)"Current";
    settings[GLOB_EnqueueMode].detail.mdz_switch.switch_labels[2]=(char*)"Last";
    
    settings[GLOB_PlayEnqueueAction].type=MDZ_SWITCH;
    settings[GLOB_PlayEnqueueAction].label=(char*)"Default Action";
    settings[GLOB_PlayEnqueueAction].description=NULL;
    settings[GLOB_PlayEnqueueAction].family=MDZ_SETTINGS_GLOBAL_PLAYER;
    settings[GLOB_PlayEnqueueAction].sub_family=0;
    settings[GLOB_PlayEnqueueAction].detail.mdz_switch.switch_value=0;
    settings[GLOB_PlayEnqueueAction].detail.mdz_switch.switch_value_nb=3;
    settings[GLOB_PlayEnqueueAction].detail.mdz_switch.switch_labels=(char**)malloc(settings[GLOB_PlayEnqueueAction].detail.mdz_switch.switch_value_nb*sizeof(char*));
    settings[GLOB_PlayEnqueueAction].detail.mdz_switch.switch_labels[0]=(char*)"Play";
    settings[GLOB_PlayEnqueueAction].detail.mdz_switch.switch_labels[1]=(char*)"Enqueue";
    settings[GLOB_PlayEnqueueAction].detail.mdz_switch.switch_labels[2]=(char*)"Enq.&Play";
    
    settings[GLOB_AfterDownloadAction].type=MDZ_SWITCH;
    settings[GLOB_AfterDownloadAction].label=(char*)"Post download action";
    settings[GLOB_AfterDownloadAction].description=NULL;
    settings[GLOB_AfterDownloadAction].family=MDZ_SETTINGS_GLOBAL_PLAYER;
    settings[GLOB_AfterDownloadAction].sub_family=0;
    settings[GLOB_AfterDownloadAction].detail.mdz_switch.switch_value=1;
    settings[GLOB_AfterDownloadAction].detail.mdz_switch.switch_value_nb=3;
    settings[GLOB_AfterDownloadAction].detail.mdz_switch.switch_labels=(char**)malloc(settings[GLOB_AfterDownloadAction].detail.mdz_switch.switch_value_nb*sizeof(char*));
    settings[GLOB_AfterDownloadAction].detail.mdz_switch.switch_labels[0]=(char*)"Nothing";
    settings[GLOB_AfterDownloadAction].detail.mdz_switch.switch_labels[1]=(char*)"Enqueue";
    settings[GLOB_AfterDownloadAction].detail.mdz_switch.switch_labels[2]=(char*)"Play";
    
    settings[GLOB_CoverFlow].label=(char*)"Coverflow";
    settings[GLOB_CoverFlow].description=NULL;
    settings[GLOB_CoverFlow].family=MDZ_SETTINGS_GLOBAL_PLAYER;
    settings[GLOB_CoverFlow].sub_family=0;
    settings[GLOB_CoverFlow].type=MDZ_BOOLSWITCH;
    settings[GLOB_CoverFlow].detail.mdz_boolswitch.switch_value=1;
    
    settings[GLOB_PlayerViewOnPlay].label=(char*)"Player view on play";
    settings[GLOB_PlayerViewOnPlay].description=NULL;
    settings[GLOB_PlayerViewOnPlay].family=MDZ_SETTINGS_GLOBAL_PLAYER;
    settings[GLOB_PlayerViewOnPlay].sub_family=0;
    settings[GLOB_PlayerViewOnPlay].type=MDZ_BOOLSWITCH;
    settings[GLOB_PlayerViewOnPlay].detail.mdz_boolswitch.switch_value=0;
    
    /////////////////////////////////////
    //GLOBAL FTP
    /////////////////////////////////////
    settings[FTP_STATUS].label=(char*)"Server status";
    settings[FTP_STATUS].description=NULL;
    settings[FTP_STATUS].family=MDZ_SETTINGS_GLOBAL_FTP;
    settings[FTP_STATUS].sub_family=1;
    settings[FTP_STATUS].type=MDZ_MSGBOX;
    settings[FTP_STATUS].detail.mdz_msgbox.text=(char*)malloc(strlen("Inactive")+1);
    strcpy(settings[FTP_STATUS].detail.mdz_msgbox.text,"Inactive");
    
    
    settings[FTP_ONOFF].type=MDZ_SWITCH;
    settings[FTP_ONOFF].label=(char*)"FTP Server";
    settings[FTP_ONOFF].description=NULL;
    settings[FTP_ONOFF].family=MDZ_SETTINGS_GLOBAL_FTP;
    settings[FTP_ONOFF].callback=&optFTPSwitchChanged;
    settings[FTP_ONOFF].sub_family=0;
    settings[FTP_ONOFF].detail.mdz_switch.switch_value=0;
    settings[FTP_ONOFF].detail.mdz_switch.switch_value_nb=2;
    settings[FTP_ONOFF].detail.mdz_switch.switch_labels=(char**)malloc(settings[FTP_ONOFF].detail.mdz_switch.switch_value_nb*sizeof(char*));
    settings[FTP_ONOFF].detail.mdz_switch.switch_labels[0]=(char*)"Stop";
    settings[FTP_ONOFF].detail.mdz_switch.switch_labels[1]=(char*)"Run";    
    
    settings[FTP_ANONYMOUS].label=(char*)"Authorize anonymous";
    settings[FTP_ANONYMOUS].description=NULL;
    settings[FTP_ANONYMOUS].family=MDZ_SETTINGS_GLOBAL_FTP;
    settings[FTP_ANONYMOUS].sub_family=1;
    settings[FTP_ANONYMOUS].type=MDZ_BOOLSWITCH;
    settings[FTP_ANONYMOUS].detail.mdz_boolswitch.switch_value=1;
    
    settings[FTP_USER].label=(char*)"User";
    settings[FTP_USER].description=NULL;
    settings[FTP_USER].family=MDZ_SETTINGS_GLOBAL_FTP;
    settings[FTP_USER].sub_family=0;
    settings[FTP_USER].type=MDZ_TEXTBOX;
    settings[FTP_USER].detail.mdz_textbox.text=NULL;//(char*)"modizer";
    
    settings[FTP_PASSWORD].label=(char*)"Password";
    settings[FTP_PASSWORD].description=NULL;
    settings[FTP_PASSWORD].family=MDZ_SETTINGS_GLOBAL_FTP;
    settings[FTP_PASSWORD].sub_family=0;
    settings[FTP_PASSWORD].type=MDZ_TEXTBOX;
    settings[FTP_PASSWORD].detail.mdz_textbox.text=NULL;//(char*)"modizer";
    
    settings[FTP_PORT].label=(char*)"Port";
    settings[FTP_PORT].description=NULL;
    settings[FTP_PORT].family=MDZ_SETTINGS_GLOBAL_FTP;
    settings[FTP_PORT].sub_family=0;
    settings[FTP_PORT].type=MDZ_TEXTBOX;
    settings[FTP_PORT].detail.mdz_textbox.text=(char*)malloc(strlen("21")+1);
    strcpy(settings[FTP_PORT].detail.mdz_textbox.text,"21");
    
    /////////////////////////////////////
    //Visualizers
    /////////////////////////////////////
    settings[GLOB_FXRandom].label=(char*)"Random FX";
    settings[GLOB_FXRandom].description=NULL;
    settings[GLOB_FXRandom].family=MDZ_SETTINGS_GLOBAL_VISU;
    settings[GLOB_FXRandom].sub_family=0;
    settings[GLOB_FXRandom].type=MDZ_BOOLSWITCH;
    settings[GLOB_FXRandom].detail.mdz_boolswitch.switch_value=0;
    
    settings[GLOB_FXAlpha].label=(char*)"FX Transparency";
    settings[GLOB_FXAlpha].description=NULL;
    settings[GLOB_FXAlpha].family=MDZ_SETTINGS_GLOBAL_VISU;
    settings[GLOB_FXAlpha].sub_family=0;
    settings[GLOB_FXAlpha].type=MDZ_SLIDER_CONTINUOUS;
    settings[GLOB_FXAlpha].detail.mdz_slider.slider_value=0.7;
    settings[GLOB_FXAlpha].detail.mdz_slider.slider_min_value=0;
    settings[GLOB_FXAlpha].detail.mdz_slider.slider_max_value=1;
    
    settings[GLOB_FXBeat].label=(char*)"Beat FX";
    settings[GLOB_FXBeat].description=NULL;
    settings[GLOB_FXBeat].family=MDZ_SETTINGS_GLOBAL_VISU;
    settings[GLOB_FXBeat].sub_family=0;
    settings[GLOB_FXBeat].type=MDZ_BOOLSWITCH;
    settings[GLOB_FXBeat].detail.mdz_boolswitch.switch_value=0;
    
    settings[GLOB_FXOscillo].type=MDZ_SWITCH;
    settings[GLOB_FXOscillo].label=(char*)"Oscillo";
    settings[GLOB_FXOscillo].description=NULL;
    settings[GLOB_FXOscillo].family=MDZ_SETTINGS_GLOBAL_VISU;
    settings[GLOB_FXOscillo].sub_family=0;
    settings[GLOB_FXOscillo].detail.mdz_switch.switch_value=0;
    settings[GLOB_FXOscillo].detail.mdz_switch.switch_value_nb=3;
    settings[GLOB_FXOscillo].detail.mdz_switch.switch_labels=(char**)malloc(settings[GLOB_FXOscillo].detail.mdz_switch.switch_value_nb*sizeof(char*));
    settings[GLOB_FXOscillo].detail.mdz_switch.switch_labels[0]=(char*)"Off";
    settings[GLOB_FXOscillo].detail.mdz_switch.switch_labels[1]=(char*)"Split";
    settings[GLOB_FXOscillo].detail.mdz_switch.switch_labels[2]=(char*)"Comb";
    
    settings[GLOB_FXSpectrum].type=MDZ_SWITCH;
    settings[GLOB_FXSpectrum].label=(char*)"2D Spectrum";
    settings[GLOB_FXSpectrum].description=NULL;
    settings[GLOB_FXSpectrum].family=MDZ_SETTINGS_GLOBAL_VISU;
    settings[GLOB_FXSpectrum].sub_family=0;
    settings[GLOB_FXSpectrum].detail.mdz_switch.switch_value=0;
    settings[GLOB_FXSpectrum].detail.mdz_switch.switch_value_nb=3;
    settings[GLOB_FXSpectrum].detail.mdz_switch.switch_labels=(char**)malloc(settings[GLOB_FXSpectrum].detail.mdz_switch.switch_value_nb*sizeof(char*));
    settings[GLOB_FXSpectrum].detail.mdz_switch.switch_labels[0]=(char*)"Off";
    settings[GLOB_FXSpectrum].detail.mdz_switch.switch_labels[1]=(char*)"1";
    settings[GLOB_FXSpectrum].detail.mdz_switch.switch_labels[2]=(char*)"2";
    
    settings[GLOB_FXMODPattern].type=MDZ_SWITCH;
    settings[GLOB_FXMODPattern].label=(char*)"MOD Pattern";
    settings[GLOB_FXMODPattern].description=NULL;
    settings[GLOB_FXMODPattern].family=MDZ_SETTINGS_GLOBAL_VISU;
    settings[GLOB_FXMODPattern].sub_family=0;
    settings[GLOB_FXMODPattern].detail.mdz_switch.switch_value=0;
    settings[GLOB_FXMODPattern].detail.mdz_switch.switch_value_nb=3;
    settings[GLOB_FXMODPattern].detail.mdz_switch.switch_labels=(char**)malloc(settings[GLOB_FXMODPattern].detail.mdz_switch.switch_value_nb*sizeof(char*));
    settings[GLOB_FXMODPattern].detail.mdz_switch.switch_labels[0]=(char*)"Off";
    settings[GLOB_FXMODPattern].detail.mdz_switch.switch_labels[1]=(char*)"1";
    settings[GLOB_FXMODPattern].detail.mdz_switch.switch_labels[2]=(char*)"2";
    
    settings[GLOB_FXMIDIPattern].type=MDZ_SWITCH;
    settings[GLOB_FXMIDIPattern].label=(char*)"Note display";
    settings[GLOB_FXMIDIPattern].description=NULL;
    settings[GLOB_FXMIDIPattern].family=MDZ_SETTINGS_GLOBAL_VISU;
    settings[GLOB_FXMIDIPattern].sub_family=0;
    settings[GLOB_FXMIDIPattern].detail.mdz_switch.switch_value=0;
    settings[GLOB_FXMIDIPattern].detail.mdz_switch.switch_value_nb=3;
    settings[GLOB_FXMIDIPattern].detail.mdz_switch.switch_labels=(char**)malloc(settings[GLOB_FXMIDIPattern].detail.mdz_switch.switch_value_nb*sizeof(char*));
    settings[GLOB_FXMIDIPattern].detail.mdz_switch.switch_labels[0]=(char*)"Off";
    settings[GLOB_FXMIDIPattern].detail.mdz_switch.switch_labels[1]=(char*)"Hori";
    settings[GLOB_FXMIDIPattern].detail.mdz_switch.switch_labels[2]=(char*)"Vert";
    
    settings[GLOB_FXPiano].type=MDZ_SWITCH;
    settings[GLOB_FXPiano].label=(char*)"Piano mode";
    settings[GLOB_FXPiano].description=NULL;
    settings[GLOB_FXPiano].family=MDZ_SETTINGS_GLOBAL_VISU;
    settings[GLOB_FXPiano].sub_family=0;
    settings[GLOB_FXPiano].detail.mdz_switch.switch_value=0;
    settings[GLOB_FXPiano].detail.mdz_switch.switch_value_nb=3;
    settings[GLOB_FXPiano].detail.mdz_switch.switch_labels=(char**)malloc(settings[GLOB_FXPiano].detail.mdz_switch.switch_value_nb*sizeof(char*));
    settings[GLOB_FXPiano].detail.mdz_switch.switch_labels[0]=(char*)"Off";
    settings[GLOB_FXPiano].detail.mdz_switch.switch_labels[1]=(char*)"1";
    settings[GLOB_FXPiano].detail.mdz_switch.switch_labels[2]=(char*)"2";
    
    settings[GLOB_FX1].label=(char*)"FX1";
    settings[GLOB_FX1].description=NULL;
    settings[GLOB_FX1].family=MDZ_SETTINGS_GLOBAL_VISU;
    settings[GLOB_FX1].sub_family=0;
    settings[GLOB_FX1].type=MDZ_BOOLSWITCH;
    settings[GLOB_FX1].detail.mdz_boolswitch.switch_value=0;
    
    settings[GLOB_FX2].type=MDZ_SWITCH;
    settings[GLOB_FX2].label=(char*)"FX2";
    settings[GLOB_FX2].description=NULL;
    settings[GLOB_FX2].family=MDZ_SETTINGS_GLOBAL_VISU;
    settings[GLOB_FX2].sub_family=0;
    settings[GLOB_FX2].detail.mdz_switch.switch_value=0;
    settings[GLOB_FX2].detail.mdz_switch.switch_value_nb=3;
    settings[GLOB_FX2].detail.mdz_switch.switch_labels=(char**)malloc(settings[GLOB_FX2].detail.mdz_switch.switch_value_nb*sizeof(char*));
    settings[GLOB_FX2].detail.mdz_switch.switch_labels[0]=(char*)"Off";
    settings[GLOB_FX2].detail.mdz_switch.switch_labels[1]=(char*)"1";
    settings[GLOB_FX2].detail.mdz_switch.switch_labels[2]=(char*)"2";
    
    settings[GLOB_FX3].type=MDZ_SWITCH;
    settings[GLOB_FX3].label=(char*)"FX3";
    settings[GLOB_FX3].description=NULL;
    settings[GLOB_FX3].family=MDZ_SETTINGS_GLOBAL_VISU;
    settings[GLOB_FX3].sub_family=0;
    settings[GLOB_FX3].detail.mdz_switch.switch_value=0;
    settings[GLOB_FX3].detail.mdz_switch.switch_value_nb=3;
    settings[GLOB_FX3].detail.mdz_switch.switch_labels=(char**)malloc(settings[GLOB_FX3].detail.mdz_switch.switch_value_nb*sizeof(char*));
    settings[GLOB_FX3].detail.mdz_switch.switch_labels[0]=(char*)"Off";
    settings[GLOB_FX3].detail.mdz_switch.switch_labels[1]=(char*)"1";
    settings[GLOB_FX3].detail.mdz_switch.switch_labels[2]=(char*)"2";
    
    settings[GLOB_FX4].label=(char*)"FX4";
    settings[GLOB_FX4].description=NULL;
    settings[GLOB_FX4].family=MDZ_SETTINGS_GLOBAL_VISU;
    settings[GLOB_FX4].sub_family=0;
    settings[GLOB_FX4].type=MDZ_BOOLSWITCH;
    settings[GLOB_FX4].detail.mdz_boolswitch.switch_value=0;
    
    settings[GLOB_FX5].type=MDZ_SWITCH;
    settings[GLOB_FX5].label=(char*)"FX5";
    settings[GLOB_FX5].description=NULL;
    settings[GLOB_FX5].family=MDZ_SETTINGS_GLOBAL_VISU;
    settings[GLOB_FX5].sub_family=0;
    settings[GLOB_FX5].detail.mdz_switch.switch_value=0;
    settings[GLOB_FX5].detail.mdz_switch.switch_value_nb=3;
    settings[GLOB_FX5].detail.mdz_switch.switch_labels=(char**)malloc(settings[GLOB_FX5].detail.mdz_switch.switch_value_nb*sizeof(char*));
    settings[GLOB_FX5].detail.mdz_switch.switch_labels[0]=(char*)"Off";
    settings[GLOB_FX5].detail.mdz_switch.switch_labels[1]=(char*)"1";
    settings[GLOB_FX5].detail.mdz_switch.switch_labels[2]=(char*)"2";
    
    settings[GLOB_FXLOD].type=MDZ_SWITCH;
    settings[GLOB_FXLOD].label=(char*)"FX Level of details";
    settings[GLOB_FXLOD].description=NULL;
    settings[GLOB_FXLOD].family=MDZ_SETTINGS_GLOBAL_VISU;
    settings[GLOB_FXLOD].sub_family=0;
    settings[GLOB_FXLOD].detail.mdz_switch.switch_value=2;
    settings[GLOB_FXLOD].detail.mdz_switch.switch_value_nb=3;
    settings[GLOB_FXLOD].detail.mdz_switch.switch_labels=(char**)malloc(settings[GLOB_FXLOD].detail.mdz_switch.switch_value_nb*sizeof(char*));
    settings[GLOB_FXLOD].detail.mdz_switch.switch_labels[0]=(char*)"Low";
    settings[GLOB_FXLOD].detail.mdz_switch.switch_labels[1]=(char*)"Med";
    settings[GLOB_FXLOD].detail.mdz_switch.switch_labels[2]=(char*)"High";
    
    /////////////////////////////////////
    //PLUGINS
    /////////////////////////////////////
    
    /////////////////////////////////////
    //MODPLUG
    /////////////////////////////////////
    settings[MDZ_SETTINGS_FAMILY_MODPLUG].type=MDZ_FAMILY;
    settings[MDZ_SETTINGS_FAMILY_MODPLUG].label=(char*)"Modplug";
    settings[MDZ_SETTINGS_FAMILY_MODPLUG].description=NULL;
    settings[MDZ_SETTINGS_FAMILY_MODPLUG].family=MDZ_SETTINGS_PLUGINS;
    settings[MDZ_SETTINGS_FAMILY_MODPLUG].sub_family=MDZ_SETTINGS_MODPLUG;
    
    settings[MODPLUG_MasterVolume].label=(char*)"Master Volume";
    settings[MODPLUG_MasterVolume].description=NULL;
    settings[MODPLUG_MasterVolume].family=MDZ_SETTINGS_MODPLUG;
    settings[MODPLUG_MasterVolume].sub_family=0;
    settings[MODPLUG_MasterVolume].type=MDZ_SLIDER_CONTINUOUS;
    settings[MODPLUG_MasterVolume].detail.mdz_slider.slider_value=0.5;
    settings[MODPLUG_MasterVolume].detail.mdz_slider.slider_min_value=0;
    settings[MODPLUG_MasterVolume].detail.mdz_slider.slider_max_value=1;
    
    settings[MODPLUG_Sampling].type=MDZ_SWITCH;
    settings[MODPLUG_Sampling].label=(char*)"Resampling";
    settings[MODPLUG_Sampling].description=NULL;
    settings[MODPLUG_Sampling].family=MDZ_SETTINGS_MODPLUG;
    settings[MODPLUG_Sampling].sub_family=0;
    settings[MODPLUG_Sampling].detail.mdz_switch.switch_value=2;
    settings[MODPLUG_Sampling].detail.mdz_switch.switch_value_nb=4;
    settings[MODPLUG_Sampling].detail.mdz_switch.switch_labels=(char**)malloc(settings[MODPLUG_Sampling].detail.mdz_switch.switch_value_nb*sizeof(char*));
    settings[MODPLUG_Sampling].detail.mdz_switch.switch_labels[0]=(char*)"Near";
    settings[MODPLUG_Sampling].detail.mdz_switch.switch_labels[1]=(char*)"Lin";
    settings[MODPLUG_Sampling].detail.mdz_switch.switch_labels[2]=(char*)"Spli";
    settings[MODPLUG_Sampling].detail.mdz_switch.switch_labels[3]=(char*)"FIR";
    
    settings[MODPLUG_Megabass].type=MDZ_BOOLSWITCH;
    settings[MODPLUG_Megabass].label=(char*)"Megabass";
    settings[MODPLUG_Megabass].description=NULL;
    settings[MODPLUG_Megabass].family=MDZ_SETTINGS_MODPLUG;
    settings[MODPLUG_Megabass].sub_family=0;
    settings[MODPLUG_Megabass].detail.mdz_boolswitch.switch_value=0;
    
    settings[MODPLUG_BassAmount].label=(char*)"Megabass Strength";
    settings[MODPLUG_BassAmount].description=NULL;
    settings[MODPLUG_BassAmount].family=MDZ_SETTINGS_MODPLUG;
    settings[MODPLUG_BassAmount].sub_family=0;
    settings[MODPLUG_BassAmount].type=MDZ_SLIDER_CONTINUOUS;
    settings[MODPLUG_BassAmount].detail.mdz_slider.slider_value=0.7;
    settings[MODPLUG_BassAmount].detail.mdz_slider.slider_min_value=0;
    settings[MODPLUG_BassAmount].detail.mdz_slider.slider_max_value=1;
    
    settings[MODPLUG_BassRange].label=(char*)"Megabass Range";
    settings[MODPLUG_BassRange].description=NULL;
    settings[MODPLUG_BassRange].family=MDZ_SETTINGS_MODPLUG;
    settings[MODPLUG_BassRange].sub_family=0;
    settings[MODPLUG_BassRange].type=MDZ_SLIDER_CONTINUOUS;
    settings[MODPLUG_BassRange].detail.mdz_slider.slider_value=0.3;
    settings[MODPLUG_BassRange].detail.mdz_slider.slider_min_value=0;
    settings[MODPLUG_BassRange].detail.mdz_slider.slider_max_value=1;
    
    settings[MODPLUG_Surround].type=MDZ_BOOLSWITCH;
    settings[MODPLUG_Surround].label=(char*)"Surround";
    settings[MODPLUG_Surround].description=NULL;
    settings[MODPLUG_Surround].family=MDZ_SETTINGS_MODPLUG;
    settings[MODPLUG_Surround].sub_family=0;
    settings[MODPLUG_Surround].detail.mdz_boolswitch.switch_value=0;
    
    settings[MODPLUG_SurroundDepth].label=(char*)"Surround Depth";
    settings[MODPLUG_SurroundDepth].description=NULL;
    settings[MODPLUG_SurroundDepth].family=MDZ_SETTINGS_MODPLUG;
    settings[MODPLUG_SurroundDepth].sub_family=0;
    settings[MODPLUG_SurroundDepth].type=MDZ_SLIDER_CONTINUOUS;
    settings[MODPLUG_SurroundDepth].detail.mdz_slider.slider_value=0.9;
    settings[MODPLUG_SurroundDepth].detail.mdz_slider.slider_min_value=0;
    settings[MODPLUG_SurroundDepth].detail.mdz_slider.slider_max_value=1;
    
    settings[MODPLUG_SurroundDelay].label=(char*)"Surround Delay";
    settings[MODPLUG_SurroundDelay].description=NULL;
    settings[MODPLUG_SurroundDelay].family=MDZ_SETTINGS_MODPLUG;
    settings[MODPLUG_SurroundDelay].sub_family=0;
    settings[MODPLUG_SurroundDelay].type=MDZ_SLIDER_CONTINUOUS;
    settings[MODPLUG_SurroundDelay].detail.mdz_slider.slider_value=0.8;
    settings[MODPLUG_SurroundDelay].detail.mdz_slider.slider_min_value=0;
    settings[MODPLUG_SurroundDelay].detail.mdz_slider.slider_max_value=1;
    
    settings[MODPLUG_Reverb].type=MDZ_BOOLSWITCH;
    settings[MODPLUG_Reverb].label=(char*)"Reverb";
    settings[MODPLUG_Reverb].description=NULL;
    settings[MODPLUG_Reverb].family=MDZ_SETTINGS_MODPLUG;
    settings[MODPLUG_Reverb].sub_family=0;
    settings[MODPLUG_Reverb].detail.mdz_boolswitch.switch_value=0;
    
    settings[MODPLUG_ReverbDepth].label=(char*)"Reverb Depth";
    settings[MODPLUG_ReverbDepth].description=NULL;
    settings[MODPLUG_ReverbDepth].family=MDZ_SETTINGS_MODPLUG;
    settings[MODPLUG_ReverbDepth].sub_family=0;
    settings[MODPLUG_ReverbDepth].type=MDZ_SLIDER_CONTINUOUS;
    settings[MODPLUG_ReverbDepth].detail.mdz_slider.slider_value=0.8;
    settings[MODPLUG_ReverbDepth].detail.mdz_slider.slider_min_value=0;
    settings[MODPLUG_ReverbDepth].detail.mdz_slider.slider_max_value=1;
    
    settings[MODPLUG_ReverbDelay].label=(char*)"Reverb Delay";
    settings[MODPLUG_ReverbDelay].description=NULL;
    settings[MODPLUG_ReverbDelay].family=MDZ_SETTINGS_MODPLUG;
    settings[MODPLUG_ReverbDelay].sub_family=0;
    settings[MODPLUG_ReverbDelay].type=MDZ_SLIDER_CONTINUOUS;
    settings[MODPLUG_ReverbDelay].detail.mdz_slider.slider_value=0.7;
    settings[MODPLUG_ReverbDelay].detail.mdz_slider.slider_min_value=0;
    settings[MODPLUG_ReverbDelay].detail.mdz_slider.slider_max_value=1;
    
    settings[MODPLUG_StereoSeparation].label=(char*)"Panning";
    settings[MODPLUG_StereoSeparation].description=NULL;
    settings[MODPLUG_StereoSeparation].family=MDZ_SETTINGS_MODPLUG;
    settings[MODPLUG_StereoSeparation].sub_family=0;
    settings[MODPLUG_StereoSeparation].type=MDZ_SLIDER_CONTINUOUS;
    settings[MODPLUG_StereoSeparation].detail.mdz_slider.slider_value=0.5;
    settings[MODPLUG_StereoSeparation].detail.mdz_slider.slider_min_value=0;
    settings[MODPLUG_StereoSeparation].detail.mdz_slider.slider_max_value=1;
    
    
    /////////////////////////////////////
    //DUMB
    /////////////////////////////////////
    settings[MDZ_SETTINGS_FAMILY_DUMB].type=MDZ_FAMILY;
    settings[MDZ_SETTINGS_FAMILY_DUMB].label=(char*)"Dumb";
    settings[MDZ_SETTINGS_FAMILY_DUMB].description=NULL;
    settings[MDZ_SETTINGS_FAMILY_DUMB].family=MDZ_SETTINGS_PLUGINS;
    settings[MDZ_SETTINGS_FAMILY_DUMB].sub_family=MDZ_SETTINGS_DUMB;
    
    settings[DUMB_MasterVolume].label=(char*)"Master Volume";
    settings[DUMB_MasterVolume].description=NULL;
    settings[DUMB_MasterVolume].family=MDZ_SETTINGS_DUMB;
    settings[DUMB_MasterVolume].sub_family=0;
    settings[DUMB_MasterVolume].type=MDZ_SLIDER_CONTINUOUS;
    settings[DUMB_MasterVolume].detail.mdz_slider.slider_value=0.5;
    settings[DUMB_MasterVolume].detail.mdz_slider.slider_min_value=0;
    settings[DUMB_MasterVolume].detail.mdz_slider.slider_max_value=1;
    
    settings[DUMB_Resampling].type=MDZ_SWITCH;
    settings[DUMB_Resampling].label=(char*)"Resampling";
    settings[DUMB_Resampling].description=NULL;
    settings[DUMB_Resampling].family=MDZ_SETTINGS_DUMB;
    settings[DUMB_Resampling].sub_family=0;
    settings[DUMB_Resampling].detail.mdz_switch.switch_value=1;
    settings[DUMB_Resampling].detail.mdz_switch.switch_value_nb=3;
    settings[DUMB_Resampling].detail.mdz_switch.switch_labels=(char**)malloc(settings[DUMB_Resampling].detail.mdz_switch.switch_value_nb*sizeof(char*));
    settings[DUMB_Resampling].detail.mdz_switch.switch_labels[0]=(char*)"Alias";
    settings[DUMB_Resampling].detail.mdz_switch.switch_labels[1]=(char*)"Lin";
    settings[DUMB_Resampling].detail.mdz_switch.switch_labels[2]=(char*)"Cubic";
    
    
    
    /////////////////////////////////////
    //TIMIDITY
    /////////////////////////////////////
    settings[MDZ_SETTINGS_FAMILY_TIMIDITY].type=MDZ_FAMILY;
    settings[MDZ_SETTINGS_FAMILY_TIMIDITY].label=(char*)"Timidity";
    settings[MDZ_SETTINGS_FAMILY_TIMIDITY].description=NULL;
    settings[MDZ_SETTINGS_FAMILY_TIMIDITY].family=MDZ_SETTINGS_PLUGINS;
    settings[MDZ_SETTINGS_FAMILY_TIMIDITY].sub_family=MDZ_SETTINGS_TIMIDITY;
    
    settings[TIM_Polyphony].label=(char*)"Midi polyphony";
    settings[TIM_Polyphony].description=NULL;
    settings[TIM_Polyphony].family=MDZ_SETTINGS_TIMIDITY;
    settings[TIM_Polyphony].sub_family=0;
    settings[TIM_Polyphony].type=MDZ_SLIDER_DISCRETE;
    settings[TIM_Polyphony].detail.mdz_slider.slider_value=128;
    settings[TIM_Polyphony].detail.mdz_slider.slider_min_value=64;
    settings[TIM_Polyphony].detail.mdz_slider.slider_max_value=256;
    
    settings[TIM_Chorus].type=MDZ_BOOLSWITCH;
    settings[TIM_Chorus].label=(char*)"Chorus";
    settings[TIM_Chorus].description=NULL;
    settings[TIM_Chorus].family=MDZ_SETTINGS_TIMIDITY;
    settings[TIM_Chorus].sub_family=0;
    settings[TIM_Chorus].detail.mdz_boolswitch.switch_value=1;
    
    settings[TIM_Reverb].type=MDZ_BOOLSWITCH;
    settings[TIM_Reverb].label=(char*)"Reverb";
    settings[TIM_Reverb].description=NULL;
    settings[TIM_Reverb].family=MDZ_SETTINGS_TIMIDITY;
    settings[TIM_Reverb].sub_family=0;
    settings[TIM_Reverb].detail.mdz_boolswitch.switch_value=1;
    
    settings[TIM_LPFilter].type=MDZ_BOOLSWITCH;
    settings[TIM_LPFilter].label=(char*)"LPFilter";
    settings[TIM_LPFilter].description=NULL;
    settings[TIM_LPFilter].family=MDZ_SETTINGS_TIMIDITY;
    settings[TIM_LPFilter].sub_family=0;
    settings[TIM_LPFilter].detail.mdz_boolswitch.switch_value=1;
    
    settings[TIM_Resample].type=MDZ_SWITCH;
    settings[TIM_Resample].label=(char*)"Resampling";
    settings[TIM_Resample].description=NULL;
    settings[TIM_Resample].family=MDZ_SETTINGS_TIMIDITY;
    settings[TIM_Resample].sub_family=0;
    settings[TIM_Resample].detail.mdz_switch.switch_value=1;
    settings[TIM_Resample].detail.mdz_switch.switch_value_nb=5;
    settings[TIM_Resample].detail.mdz_switch.switch_labels=(char**)malloc(settings[TIM_Resample].detail.mdz_switch.switch_value_nb*sizeof(char*));
    settings[TIM_Resample].detail.mdz_switch.switch_labels[0]=(char*)"None";
    settings[TIM_Resample].detail.mdz_switch.switch_labels[1]=(char*)"Line";
    settings[TIM_Resample].detail.mdz_switch.switch_labels[2]=(char*)"Spli";
    settings[TIM_Resample].detail.mdz_switch.switch_labels[3]=(char*)"Gaus";
    settings[TIM_Resample].detail.mdz_switch.switch_labels[4]=(char*)"Newt";
    
    /////////////////////////////////////
    //GME
    /////////////////////////////////////
    
    /////////////////////////////////////
    //SID
    /////////////////////////////////////
    settings[MDZ_SETTINGS_FAMILY_SID].type=MDZ_FAMILY;
    settings[MDZ_SETTINGS_FAMILY_SID].label=(char*)"SID";
    settings[MDZ_SETTINGS_FAMILY_SID].description=NULL;
    settings[MDZ_SETTINGS_FAMILY_SID].family=MDZ_SETTINGS_PLUGINS;
    settings[MDZ_SETTINGS_FAMILY_SID].sub_family=MDZ_SETTINGS_SID;
    
    settings[SID_Filter].type=MDZ_BOOLSWITCH;
    settings[SID_Filter].label=(char*)"Filter";
    settings[SID_Filter].description=NULL;
    settings[SID_Filter].family=MDZ_SETTINGS_SID;
    settings[SID_Filter].sub_family=0;
    settings[SID_Filter].detail.mdz_boolswitch.switch_value=1;
    
    settings[SID_Optim].type=MDZ_SWITCH;
    settings[SID_Optim].label=(char*)"Optim";
    settings[SID_Optim].description=NULL;
    settings[SID_Optim].family=MDZ_SETTINGS_SID;
    settings[SID_Optim].sub_family=0;
    settings[SID_Optim].detail.mdz_switch.switch_value=1;
    settings[SID_Optim].detail.mdz_switch.switch_value_nb=3;
    settings[SID_Optim].detail.mdz_switch.switch_labels=(char**)malloc(settings[SID_Optim].detail.mdz_switch.switch_value_nb*sizeof(char*));
    settings[SID_Optim].detail.mdz_switch.switch_labels[0]=(char*)"Off";
    settings[SID_Optim].detail.mdz_switch.switch_labels[1]=(char*)"Std";
    settings[SID_Optim].detail.mdz_switch.switch_labels[2]=(char*)"Fast";
    
    settings[SID_LibVersion].type=MDZ_SWITCH;
    settings[SID_LibVersion].label=(char*)"Library version";
    settings[SID_LibVersion].description=NULL;
    settings[SID_LibVersion].family=MDZ_SETTINGS_SID;
    settings[SID_LibVersion].sub_family=0;
    settings[SID_LibVersion].detail.mdz_switch.switch_value=1;
    settings[SID_LibVersion].detail.mdz_switch.switch_value_nb=2;
    settings[SID_LibVersion].detail.mdz_switch.switch_labels=(char**)malloc(settings[SID_LibVersion].detail.mdz_switch.switch_value_nb*sizeof(char*));
    settings[SID_LibVersion].detail.mdz_switch.switch_labels[0]=(char*)"SIDPLAY1";
    settings[SID_LibVersion].detail.mdz_switch.switch_labels[1]=(char*)"SIDPLAY2";
    
    
    
    /////////////////////////////////////
    //UADE
    /////////////////////////////////////
    settings[MDZ_SETTINGS_FAMILY_UADE].type=MDZ_FAMILY;
    settings[MDZ_SETTINGS_FAMILY_UADE].label=(char*)"UADE";
    settings[MDZ_SETTINGS_FAMILY_UADE].description=NULL;
    settings[MDZ_SETTINGS_FAMILY_UADE].family=MDZ_SETTINGS_PLUGINS;
    settings[MDZ_SETTINGS_FAMILY_UADE].sub_family=MDZ_SETTINGS_UADE;
    
    settings[UADE_Head].type=MDZ_BOOLSWITCH;
    settings[UADE_Head].label=(char*)"Headphones";
    settings[UADE_Head].description=NULL;
    settings[UADE_Head].family=MDZ_SETTINGS_UADE;
    settings[UADE_Head].sub_family=0;
    settings[UADE_Head].detail.mdz_boolswitch.switch_value=0;
    
    settings[UADE_PostFX].type=MDZ_BOOLSWITCH;
    settings[UADE_PostFX].label=(char*)"Post FX";
    settings[UADE_PostFX].description=NULL;
    settings[UADE_PostFX].family=MDZ_SETTINGS_UADE;
    settings[UADE_PostFX].sub_family=0;
    settings[UADE_PostFX].detail.mdz_boolswitch.switch_value=1;
    
    
    settings[UADE_Led].type=MDZ_BOOLSWITCH;
    settings[UADE_Led].label=(char*)"LED";
    settings[UADE_Led].description=NULL;
    settings[UADE_Led].family=MDZ_SETTINGS_UADE;
    settings[UADE_Led].sub_family=0;
    settings[UADE_Led].detail.mdz_boolswitch.switch_value=0;
    
    settings[UADE_Norm].type=MDZ_BOOLSWITCH;
    settings[UADE_Norm].label=(char*)"Normalization";
    settings[UADE_Norm].description=NULL;
    settings[UADE_Norm].family=MDZ_SETTINGS_UADE;
    settings[UADE_Norm].sub_family=0;
    settings[UADE_Norm].detail.mdz_boolswitch.switch_value=0;
    
    settings[UADE_Gain].type=MDZ_BOOLSWITCH;
    settings[UADE_Gain].label=(char*)"Gain";
    settings[UADE_Gain].description=NULL;
    settings[UADE_Gain].family=MDZ_SETTINGS_UADE;
    settings[UADE_Gain].sub_family=0;
    settings[UADE_Gain].detail.mdz_boolswitch.switch_value=0;
    
    settings[UADE_GainValue].label=(char*)"Gain Value";
    settings[UADE_GainValue].description=NULL;
    settings[UADE_GainValue].family=MDZ_SETTINGS_UADE;
    settings[UADE_GainValue].sub_family=0;
    settings[UADE_GainValue].type=MDZ_SLIDER_CONTINUOUS;
    settings[UADE_GainValue].detail.mdz_slider.slider_value=0.5;
    settings[UADE_GainValue].detail.mdz_slider.slider_min_value=0;
    settings[UADE_GainValue].detail.mdz_slider.slider_max_value=1;
    
    settings[UADE_Pan].type=MDZ_BOOLSWITCH;
    settings[UADE_Pan].label=(char*)"Panning";
    settings[UADE_Pan].description=NULL;
    settings[UADE_Pan].family=MDZ_SETTINGS_UADE;
    settings[UADE_Pan].sub_family=0;
    settings[UADE_Pan].detail.mdz_boolswitch.switch_value=1;
    
    settings[UADE_PanValue].label=(char*)"Panning Value";
    settings[UADE_PanValue].description=NULL;
    settings[UADE_PanValue].family=MDZ_SETTINGS_UADE;
    settings[UADE_PanValue].sub_family=0;
    settings[UADE_PanValue].type=MDZ_SLIDER_CONTINUOUS;
    settings[UADE_PanValue].detail.mdz_slider.slider_value=0.7;
    settings[UADE_PanValue].detail.mdz_slider.slider_min_value=0;
    settings[UADE_PanValue].detail.mdz_slider.slider_max_value=1;
    
    /////////////////////////////////////
    //SEXYPSF
    /////////////////////////////////////
    settings[MDZ_SETTINGS_FAMILY_SEXYPSF].type=MDZ_FAMILY;
    settings[MDZ_SETTINGS_FAMILY_SEXYPSF].label=(char*)"SexyPSF";
    settings[MDZ_SETTINGS_FAMILY_SEXYPSF].description=NULL;
    settings[MDZ_SETTINGS_FAMILY_SEXYPSF].family=MDZ_SETTINGS_PLUGINS;
    settings[MDZ_SETTINGS_FAMILY_SEXYPSF].sub_family=MDZ_SETTINGS_SEXYPSF;
    
    settings[SEXYPSF_Interpolation].type=MDZ_SWITCH;
    settings[SEXYPSF_Interpolation].label=(char*)"Interpolation";
    settings[SEXYPSF_Interpolation].description=NULL;
    settings[SEXYPSF_Interpolation].family=MDZ_SETTINGS_SEXYPSF;
    settings[SEXYPSF_Interpolation].sub_family=0;
    settings[SEXYPSF_Interpolation].detail.mdz_switch.switch_value=1;
    settings[SEXYPSF_Interpolation].detail.mdz_switch.switch_value_nb=4;
    settings[SEXYPSF_Interpolation].detail.mdz_switch.switch_labels=(char**)malloc(settings[SEXYPSF_Interpolation].detail.mdz_switch.switch_value_nb*sizeof(char*));
    settings[SEXYPSF_Interpolation].detail.mdz_switch.switch_labels[0]=(char*)"Off";
    settings[SEXYPSF_Interpolation].detail.mdz_switch.switch_labels[1]=(char*)"Lin";
    settings[SEXYPSF_Interpolation].detail.mdz_switch.switch_labels[2]=(char*)"Gau";
    settings[SEXYPSF_Interpolation].detail.mdz_switch.switch_labels[3]=(char*)"Cub";
    
    settings[SEXYPSF_Reverb].type=MDZ_SWITCH;
    settings[SEXYPSF_Reverb].label=(char*)"Interpolation";
    settings[SEXYPSF_Reverb].description=NULL;
    settings[SEXYPSF_Reverb].family=MDZ_SETTINGS_SEXYPSF;
    settings[SEXYPSF_Reverb].sub_family=0;
    settings[SEXYPSF_Reverb].detail.mdz_switch.switch_value=1;
    settings[SEXYPSF_Reverb].detail.mdz_switch.switch_value_nb=3;
    settings[SEXYPSF_Reverb].detail.mdz_switch.switch_labels=(char**)malloc(settings[SEXYPSF_Reverb].detail.mdz_switch.switch_value_nb*sizeof(char*));
    settings[SEXYPSF_Reverb].detail.mdz_switch.switch_labels[0]=(char*)"Off";
    settings[SEXYPSF_Reverb].detail.mdz_switch.switch_labels[1]=(char*)"Fake";
    settings[SEXYPSF_Reverb].detail.mdz_switch.switch_labels[2]=(char*)"Real";
    
    /////////////////////////////////////
    //AOSDK
    /////////////////////////////////////
    settings[MDZ_SETTINGS_FAMILY_AOSDK].type=MDZ_FAMILY;
    settings[MDZ_SETTINGS_FAMILY_AOSDK].label=(char*)"AOSDK";
    settings[MDZ_SETTINGS_FAMILY_AOSDK].description=NULL;
    settings[MDZ_SETTINGS_FAMILY_AOSDK].family=MDZ_SETTINGS_PLUGINS;
    settings[MDZ_SETTINGS_FAMILY_AOSDK].sub_family=MDZ_SETTINGS_AOSDK;
    
    settings[AOSDK_Interpolation].type=MDZ_SWITCH;
    settings[AOSDK_Interpolation].label=(char*)"Interpolation";
    settings[AOSDK_Interpolation].description=NULL;
    settings[AOSDK_Interpolation].family=MDZ_SETTINGS_AOSDK;
    settings[AOSDK_Interpolation].sub_family=0;
    settings[AOSDK_Interpolation].detail.mdz_switch.switch_value=2;
    settings[AOSDK_Interpolation].detail.mdz_switch.switch_value_nb=4;
    settings[AOSDK_Interpolation].detail.mdz_switch.switch_labels=(char**)malloc(settings[AOSDK_Interpolation].detail.mdz_switch.switch_value_nb*sizeof(char*));
    settings[AOSDK_Interpolation].detail.mdz_switch.switch_labels[0]=(char*)"Off";
    settings[AOSDK_Interpolation].detail.mdz_switch.switch_labels[1]=(char*)"Lin";
    settings[AOSDK_Interpolation].detail.mdz_switch.switch_labels[2]=(char*)"Gau";
    settings[AOSDK_Interpolation].detail.mdz_switch.switch_labels[3]=(char*)"Cub";
    
    settings[AOSDK_Reverb].type=MDZ_BOOLSWITCH;
    settings[AOSDK_Reverb].label=(char*)"Reverb";
    settings[AOSDK_Reverb].description=NULL;
    settings[AOSDK_Reverb].family=MDZ_SETTINGS_AOSDK;
    settings[AOSDK_Reverb].sub_family=0;
    settings[AOSDK_Reverb].detail.mdz_boolswitch.switch_value=1;
    
    settings[AOSDK_DSF22KHZ].type=MDZ_SWITCH;
    settings[AOSDK_DSF22KHZ].label=(char*)"Output";
    settings[AOSDK_DSF22KHZ].description=NULL;
    settings[AOSDK_DSF22KHZ].family=MDZ_SETTINGS_AOSDK;
    settings[AOSDK_DSF22KHZ].sub_family=0;
    settings[AOSDK_DSF22KHZ].detail.mdz_switch.switch_value=1;
    settings[AOSDK_DSF22KHZ].detail.mdz_switch.switch_value_nb=2;
    settings[AOSDK_DSF22KHZ].detail.mdz_switch.switch_labels=(char**)malloc(settings[AOSDK_DSF22KHZ].detail.mdz_switch.switch_value_nb*sizeof(char*));
    settings[AOSDK_DSF22KHZ].detail.mdz_switch.switch_labels[0]=(char*)"22Khz";
    settings[AOSDK_DSF22KHZ].detail.mdz_switch.switch_labels[1]=(char*)"44Khz";
    
    settings[AOSDK_DSFDSP].type=MDZ_BOOLSWITCH;
    settings[AOSDK_DSFDSP].label=(char*)"DSF DSP";
    settings[AOSDK_DSFDSP].description=NULL;
    settings[AOSDK_DSFDSP].family=MDZ_SETTINGS_AOSDK;
    settings[AOSDK_DSFDSP].sub_family=0;
    settings[AOSDK_DSFDSP].detail.mdz_boolswitch.switch_value=1;
    
    settings[AOSDK_DSFEmuRatio].type=MDZ_SWITCH;
    settings[AOSDK_DSFEmuRatio].label=(char*)"DSF Emu Ratio";
    settings[AOSDK_DSFEmuRatio].description=NULL;
    settings[AOSDK_DSFEmuRatio].family=MDZ_SETTINGS_AOSDK;
    settings[AOSDK_DSFEmuRatio].sub_family=0;
    settings[AOSDK_DSFEmuRatio].detail.mdz_switch.switch_value=2;
    settings[AOSDK_DSFEmuRatio].detail.mdz_switch.switch_value_nb=4;
    settings[AOSDK_DSFEmuRatio].detail.mdz_switch.switch_labels=(char**)malloc(settings[AOSDK_DSFEmuRatio].detail.mdz_switch.switch_value_nb*sizeof(char*));
    settings[AOSDK_DSFEmuRatio].detail.mdz_switch.switch_labels[0]=(char*)"1";
    settings[AOSDK_DSFEmuRatio].detail.mdz_switch.switch_labels[1]=(char*)"5";
    settings[AOSDK_DSFEmuRatio].detail.mdz_switch.switch_labels[2]=(char*)"15";
    settings[AOSDK_DSFEmuRatio].detail.mdz_switch.switch_labels[3]=(char*)"30";
    
    settings[AOSDK_SSFDSP].type=MDZ_BOOLSWITCH;
    settings[AOSDK_SSFDSP].label=(char*)"SSF DSP";
    settings[AOSDK_SSFDSP].description=NULL;
    settings[AOSDK_SSFDSP].family=MDZ_SETTINGS_AOSDK;
    settings[AOSDK_SSFDSP].sub_family=0;
    settings[AOSDK_SSFDSP].detail.mdz_boolswitch.switch_value=1;
    
    settings[AOSDK_SSFEmuRatio].type=MDZ_SWITCH;
    settings[AOSDK_SSFEmuRatio].label=(char*)"SSF Emu Ratio";
    settings[AOSDK_SSFEmuRatio].description=NULL;
    settings[AOSDK_SSFEmuRatio].family=MDZ_SETTINGS_AOSDK;
    settings[AOSDK_SSFEmuRatio].sub_family=0;
    settings[AOSDK_SSFEmuRatio].detail.mdz_switch.switch_value=2;
    settings[AOSDK_SSFEmuRatio].detail.mdz_switch.switch_value_nb=4;
    settings[AOSDK_SSFEmuRatio].detail.mdz_switch.switch_labels=(char**)malloc(settings[AOSDK_SSFEmuRatio].detail.mdz_switch.switch_value_nb*sizeof(char*));
    settings[AOSDK_SSFEmuRatio].detail.mdz_switch.switch_labels[0]=(char*)"1";
    settings[AOSDK_SSFEmuRatio].detail.mdz_switch.switch_labels[1]=(char*)"5";
    settings[AOSDK_SSFEmuRatio].detail.mdz_switch.switch_labels[2]=(char*)"15";
    settings[AOSDK_SSFEmuRatio].detail.mdz_switch.switch_labels[3]=(char*)"30";
    
    /////////////////////////////////////
    //ADPLUG
    /////////////////////////////////////
    settings[MDZ_SETTINGS_FAMILY_ADPLUG].type=MDZ_FAMILY;
    settings[MDZ_SETTINGS_FAMILY_ADPLUG].label=(char*)"ADPLUG";
    settings[MDZ_SETTINGS_FAMILY_ADPLUG].description=NULL;
    settings[MDZ_SETTINGS_FAMILY_ADPLUG].family=MDZ_SETTINGS_PLUGINS;
    settings[MDZ_SETTINGS_FAMILY_ADPLUG].sub_family=MDZ_SETTINGS_ADPLUG;
    
    settings[ADPLUG_OplType].type=MDZ_SWITCH;
    settings[ADPLUG_OplType].label=(char*)"OPL Type";
    settings[ADPLUG_OplType].description=NULL;
    settings[ADPLUG_OplType].family=MDZ_SETTINGS_ADPLUG;
    settings[ADPLUG_OplType].sub_family=0;
    settings[ADPLUG_OplType].detail.mdz_switch.switch_value=1;
    settings[ADPLUG_OplType].detail.mdz_switch.switch_value_nb=3;
    settings[ADPLUG_OplType].detail.mdz_switch.switch_labels=(char**)malloc(settings[ADPLUG_OplType].detail.mdz_switch.switch_value_nb*sizeof(char*));
    settings[ADPLUG_OplType].detail.mdz_switch.switch_labels[0]=(char*)"Std";
    settings[ADPLUG_OplType].detail.mdz_switch.switch_labels[1]=(char*)"Adl";
    settings[ADPLUG_OplType].detail.mdz_switch.switch_labels[2]=(char*)"Tat";
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        current_family=MDZ_SETTINGS_ROOT;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *btn = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 61, 31)];
    [btn setBackgroundImage:[UIImage imageNamed:@"nowplaying_fwd.png"] forState:UIControlStateNormal];
    btn.adjustsImageWhenHighlighted = YES;
    [btn addTarget:self action:@selector(goPlayer) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[[UIBarButtonItem alloc] initWithCustomView: btn] autorelease];
    self.navigationItem.rightBarButtonItem = item;
    
    //TODO: a faire dans le delegate
    //    if (current_family==MDZ_SETTINGS_ROOT) [self loadSettings];
    
    //Build current mapping
    cur_settings_nb=0;
    for (int i=0,idx=0;i<MAX_SETTINGS;i++) {
        if (settings[i].family==current_family) {
            cur_settings_idx[cur_settings_nb++]=i;
            
        }
    }
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return cur_settings_nb;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title=nil;
    return title;
}




- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    NSString *footer=(settings[cur_settings_idx[section]].description?[NSString stringWithFormat:@"%s",settings[cur_settings_idx[section]].description]:nil);
    return footer;
}

- (void)boolswitchChanged:(id)sender {
    int refresh=0;
    UISwitch *sw=(UISwitch*)sender;
    NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:[[sender superview] center]];
    if (settings[cur_settings_idx[indexPath.section]].detail.mdz_boolswitch.switch_value != sw.on) refresh=1;
    settings[cur_settings_idx[indexPath.section]].detail.mdz_boolswitch.switch_value=sw.on;
    
    if (settings[cur_settings_idx[indexPath.section]].callback) {
        settings[cur_settings_idx[indexPath.section]].callback(self);
    }    
    if (refresh) [tableView reloadData];
}
- (void)segconChanged:(id)sender {
    int refresh=0;
    
    NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:[[sender superview] center]];
    if (settings[cur_settings_idx[indexPath.section]].detail.mdz_switch.switch_value !=[(UISegmentedControl*)sender selectedSegmentIndex]) refresh=1;
    settings[cur_settings_idx[indexPath.section]].detail.mdz_switch.switch_value=[(UISegmentedControl*)sender selectedSegmentIndex];
    
    if (settings[cur_settings_idx[indexPath.section]].callback) {
        settings[cur_settings_idx[indexPath.section]].callback(self);
    }    
    if (refresh) [tableView reloadData];
}
- (void)sliderChanged:(id)sender {
    NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:[[sender superview] center]];
    
    settings[cur_settings_idx[indexPath.section]].detail.mdz_slider.slider_value=((MNEValueTrackingSlider*)sender).value;
    
    if (settings[cur_settings_idx[indexPath.section]].callback) {
        settings[cur_settings_idx[indexPath.section]].callback(self);
    }    
    //    if (OPTION(video_fskip)==10) [((MNEValueTrackingSlider*)sender) setValue:10 sValue:@"AUTO"];
    //    [tableView reloadData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (settings[cur_settings_idx[textField.tag]].detail.mdz_textbox.text) {
        free(settings[cur_settings_idx[textField.tag]].detail.mdz_textbox.text);
    }
    if ([textField.text length]) {
        settings[cur_settings_idx[textField.tag]].detail.mdz_textbox.text=(char*)malloc(strlen([textField.text UTF8String]+1));
        strcpy(settings[cur_settings_idx[textField.tag]].detail.mdz_textbox.text,[textField.text UTF8String]);
    }
    [textField resignFirstResponder];
    return YES;
}



- (UITableViewCell *)tableView:(UITableView *)tabView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    NSString *cellValue;
    const NSInteger TOP_LABEL_TAG = 1001;
    UILabel *topLabel;
    UITextField *msgLabel;
    
    UISwitch *switchview;
    UISegmentedControl *segconview;
    UITextField *txtfield;
    NSMutableArray *tmpArray;
    MNEValueTrackingSlider *sliderview;
    
    
    UITableViewCell *cell = [tabView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        cell.frame=CGRectMake(0,0,tabView.frame.size.width,50);
        
        [cell setBackgroundColor:[UIColor clearColor]];
        
        /*CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = cell.bounds;
        gradient.colors = [NSArray arrayWithObjects:
                           (id)[[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1] CGColor],
                           (id)[[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1] CGColor],
                           (id)[[UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1] CGColor],
                           (id)[[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1] CGColor],
                           (id)[[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1] CGColor],
                           (id)[[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1] CGColor],
                           nil];
        gradient.locations = [NSArray arrayWithObjects:
                              (id)[NSNumber numberWithFloat:0.00f],
                              (id)[NSNumber numberWithFloat:0.03f],
                              (id)[NSNumber numberWithFloat:0.03f],
                              (id)[NSNumber numberWithFloat:0.97f],
                              (id)[NSNumber numberWithFloat:0.97f],
                              (id)[NSNumber numberWithFloat:1.00f],
                              nil];
        [cell setBackgroundView:[[UIView alloc] init]];
        [cell.backgroundView.layer insertSublayer:gradient atIndex:0];
        
        CAGradientLayer *selgrad = [CAGradientLayer layer];
        selgrad.frame = cell.bounds;
        selgrad.colors = [NSArray arrayWithObjects:
                          (id)[[UIColor colorWithRed:255.0/255.0*0.9 green:255.0/255.0*0.9 blue:255.0/255.0*0.9 alpha:1] CGColor],
                          (id)[[UIColor colorWithRed:255.0/255.0*0.9 green:255.0/255.0*0.9 blue:255.0/255.0*0.9 alpha:1] CGColor],
                          (id)[[UIColor colorWithRed:235.0/255.0*0.9 green:235.0/255.0*0.9 blue:235.0/255.0*0.9 alpha:1] CGColor],
                          (id)[[UIColor colorWithRed:240.0/255.0*0.9 green:240.0/255.0*0.9 blue:240.0/255.0*0.9 alpha:1] CGColor],
                          (id)[[UIColor colorWithRed:200.0/255.0*0.9 green:200.0/255.0*0.9 blue:200.0/255.0*0.9 alpha:1] CGColor],
                          (id)[[UIColor colorWithRed:200.0/255.0*0.9 green:200.0/255.0*0.9 blue:200.0/255.0*0.9 alpha:1] CGColor],
                          nil];
        selgrad.locations = [NSArray arrayWithObjects:
                             (id)[NSNumber numberWithFloat:0.00f],
                             (id)[NSNumber numberWithFloat:0.03f],
                             (id)[NSNumber numberWithFloat:0.03f],
                             (id)[NSNumber numberWithFloat:0.97f],
                             (id)[NSNumber numberWithFloat:0.97f],
                             (id)[NSNumber numberWithFloat:1.00f],
                             nil];
        
        [cell setSelectedBackgroundView:[[UIView alloc] init]];
        [cell.selectedBackgroundView.layer insertSublayer:selgrad atIndex:0];
        */
        
        UIImage *image = [UIImage imageNamed:@"tabview_gradient50.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.contentMode = UIViewContentModeScaleToFill;
        cell.backgroundView = imageView;
        [imageView release];
        
        
        //
        // Create the label for the top row of text
        //
        topLabel = [[[UILabel alloc] init] autorelease];
        [cell.contentView addSubview:topLabel];
        //
        // Configure the properties for the text that are the same on every row
        //
        topLabel.tag = TOP_LABEL_TAG;
        topLabel.backgroundColor = [UIColor clearColor];
        topLabel.textColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0];
        topLabel.highlightedTextColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
        topLabel.font = [UIFont boldSystemFontOfSize:14];
        topLabel.lineBreakMode=UILineBreakModeMiddleTruncation;
        topLabel.opaque=TRUE;
        topLabel.numberOfLines=0;
        
        cell.accessoryView=nil;
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        topLabel = (UILabel *)[cell viewWithTag:TOP_LABEL_TAG];
    }
    topLabel.textColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0];
    topLabel.highlightedTextColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    
    topLabel.frame= CGRectMake(4,
                               0,
                               tabView.bounds.size.width*4/10,
                               50);
    
    
    
    topLabel.text=[NSString stringWithFormat:@"%s",settings[cur_settings_idx[indexPath.section]].label];
    
    switch (settings[cur_settings_idx[indexPath.section]].type) {
        case MDZ_FAMILY:
            cell.accessoryView=nil;
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            break;
        case MDZ_BOOLSWITCH:
            switchview = [[UISwitch alloc] initWithFrame:CGRectMake(0,0,tabView.bounds.size.width*5.5f/10,40)];
            [switchview addTarget:self action:@selector(boolswitchChanged:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = switchview;
            [switchview release];
            switchview.on=settings[cur_settings_idx[indexPath.section]].detail.mdz_boolswitch.switch_value;
            break;
        case MDZ_SWITCH:{
            tmpArray=[[[NSMutableArray alloc] init] autorelease];
            for (int i=0;i<settings[cur_settings_idx[indexPath.section]].detail.mdz_switch.switch_value_nb;i++) {
                [tmpArray addObject:[NSString stringWithFormat:@"%s",settings[cur_settings_idx[indexPath.section]].detail.mdz_switch.switch_labels[i]]];
            }
            segconview = [[UISegmentedControl alloc] initWithItems:tmpArray];
            segconview.frame=CGRectMake(0,0,tabView.bounds.size.width*5.5f/10,30);
            //            segconview.
            UIFont *font = [UIFont boldSystemFontOfSize:12.0f];
            NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                                   forKey:UITextAttributeFont];
            [segconview setTitleTextAttributes:attributes
                                      forState:UIControlStateNormal];
            
            //            segconview.segmentedControlStyle = UISegmentedControlStyleBar;
            [segconview addTarget:self action:@selector(segconChanged:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = segconview;
            [segconview release];
            segconview.selectedSegmentIndex=settings[cur_settings_idx[indexPath.section]].detail.mdz_switch.switch_value;
        }
            break;
        case MDZ_SLIDER_CONTINUOUS:
            sliderview = [[MNEValueTrackingSlider alloc] initWithFrame:CGRectMake(0,0,tabView.bounds.size.width*5.5f/10,30)];
            sliderview.integerMode=0;
            [sliderview setMaximumValue:settings[cur_settings_idx[indexPath.section]].detail.mdz_slider.slider_max_value];
            [sliderview setMinimumValue:settings[cur_settings_idx[indexPath.section]].detail.mdz_slider.slider_min_value];
            [sliderview setContinuous:true];
            sliderview.value=settings[cur_settings_idx[indexPath.section]].detail.mdz_slider.slider_value;
            [sliderview addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = sliderview;
            [sliderview release];
            break;
        case MDZ_SLIDER_DISCRETE:
            sliderview = [[MNEValueTrackingSlider alloc] initWithFrame:CGRectMake(0,0,tabView.bounds.size.width*5.5f/10,30)];
            sliderview.integerMode=1;
            [sliderview setMaximumValue:settings[cur_settings_idx[indexPath.section]].detail.mdz_slider.slider_max_value];
            [sliderview setMinimumValue:settings[cur_settings_idx[indexPath.section]].detail.mdz_slider.slider_min_value];
            [sliderview setContinuous:true];
            sliderview.value=settings[cur_settings_idx[indexPath.section]].detail.mdz_slider.slider_value;
            [sliderview addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = sliderview;
            [sliderview release];
            break;
        case MDZ_TEXTBOX:
            txtfield = [[UITextField alloc] initWithFrame:CGRectMake(0,0,tabView.bounds.size.width*5.5f/10,30)];
            
            txtfield.borderStyle = UITextBorderStyleRoundedRect;
            txtfield.font = [UIFont systemFontOfSize:15];
            txtfield.autocorrectionType = UITextAutocorrectionTypeNo;
            txtfield.keyboardType = UIKeyboardTypeASCIICapable;
            txtfield.returnKeyType = UIReturnKeyDone;
            txtfield.clearButtonMode = UITextFieldViewModeWhileEditing;
            txtfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            txtfield.delegate = self;
            txtfield.tag=indexPath.section;
            
            if (settings[cur_settings_idx[indexPath.section]].detail.mdz_textbox.text) txtfield.text=[NSString stringWithFormat:@"%s",settings[cur_settings_idx[indexPath.section]].detail.mdz_textbox.text];
            else txtfield.text=@"";
            cell.accessoryView = txtfield;
            [txtfield release];
            break;
        case MDZ_MSGBOX:
            msgLabel = [[UITextField alloc] initWithFrame:CGRectMake(0,0,tabView.bounds.size.width*5.5f/10,30)];
            msgLabel.tag=indexPath.section;
            
            //msgLabel.backgroundColor = [UIColor clearColor];
//            msgLabel.textColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0];
            
            msgLabel.borderStyle = UITextBorderStyleRoundedRect;
            msgLabel.font = [UIFont systemFontOfSize:12];
            msgLabel.autocorrectionType = UITextAutocorrectionTypeNo;
            msgLabel.keyboardType = UIKeyboardTypeASCIICapable;
            msgLabel.returnKeyType = UIReturnKeyDone;
            msgLabel.clearButtonMode = UITextFieldViewModeWhileEditing;
            msgLabel.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            msgLabel.delegate = self;
            msgLabel.enabled=FALSE;
            msgLabel.tag=indexPath.section;

            
            
            if (settings[cur_settings_idx[indexPath.section]].detail.mdz_msgbox.text) msgLabel.text=[NSString stringWithFormat:@"%s",settings[cur_settings_idx[indexPath.section]].detail.mdz_textbox.text];
            else msgLabel.text=@"";
            cell.accessoryView = msgLabel;
            [msgLabel release];
            break;
    }
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tabView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tabView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tabView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tabView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tabView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tabView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingsGenViewController *settingsVC;
    
    if (settings[cur_settings_idx[indexPath.section]].type==MDZ_FAMILY) {
        settingsVC=[[[SettingsGenViewController alloc] initWithNibName:@"SettingsViewController" bundle:[NSBundle mainBundle]] autorelease];
        settingsVC->detailViewController=detailViewController;
        settingsVC.title=NSLocalizedString(@"General Settings",@"");
        settingsVC->current_family=settings[cur_settings_idx[indexPath.section]].sub_family;
        [self.navigationController pushViewController:settingsVC animated:YES];
    }
}

#pragma mark - FTP and usefull methods
- (BOOL)addSkipBackupAttributeToItemAtPath:(NSString*)path
{
    //    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //  NSString *documentsDirectory = [paths objectAtIndex:0];
    const char* filePath = [path fileSystemRepresentation];
    
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;
}
-(void) updateFilesDoNotBackupAttributes {
    NSError *error;
    NSArray *dirContent;
    int result;
    //BOOL isDir;
    NSFileManager *mFileMngr = [[NSFileManager alloc] init];
    NSString *cpath=[NSHomeDirectory() stringByAppendingPathComponent:  @"Documents/"];
    NSString *file;
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    
    dirContent=[mFileMngr subpathsOfDirectoryAtPath:cpath error:&error];
    for (file in dirContent) {
        //NSLog(@"%@",file);
        //        [mFileMngr fileExistsAtPath:[cpath stringByAppendingFormat:@"/%@",file] isDirectory:&isDir];
        result = setxattr([[cpath stringByAppendingFormat:@"/%@",file] fileSystemRepresentation], attrName, &attrValue, sizeof(attrValue), 0, 0);
        if (result) NSLog(@"Issue %d when settings nobackup flag on %@",result,[cpath stringByAppendingFormat:@"/%@",file]);
    }
    [mFileMngr release];
}


- (NSString *)getIPAddress {
	NSString *address = @"error";
	struct ifaddrs *interfaces = NULL;
	struct ifaddrs *temp_addr = NULL;
	int success = 0;
	
	// retrieve the current interfaces - returns 0 on success
	success = getifaddrs(&interfaces);
	if (success == 0)
	{
		// Loop through linked list of interfaces
		temp_addr = interfaces;
		while(temp_addr != NULL)
		{
			if(temp_addr->ifa_addr->sa_family == AF_INET)
			{
				// Check if interface is en0 which is the wifi connection on the iPhone
				if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
				{
					// Get NSString from C String
					address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
				}
			}
			
			temp_addr = temp_addr->ifa_next;
		}
	}
	
	// Free memory
	freeifaddrs(interfaces);
	
	return address;
}

-(bool)startFTPServer {
	int ftpport=0;
	sscanf(settings[FTP_PORT].detail.mdz_textbox.text,"%d",&ftpport);
	if (ftpport==0) return FALSE;
	
    if (!ftpserver) ftpserver = new CFtpServer();
    bServerRunning = false;
    
    ftpserver->SetMaxPasswordTries( 3 );
	ftpserver->SetNoLoginTimeout( 45 ); // seconds
	ftpserver->SetNoTransferTimeout( 90 ); // seconds
	ftpserver->SetDataPortRange( 1024, 4096 ); // data TCP-Port range = [100-999]
	ftpserver->SetCheckPassDelay( 0 ); // milliseconds. Bruteforcing protection.
	
	pUser = ftpserver->AddUser(settings[FTP_USER].detail.mdz_textbox.text,
							   settings[FTP_PASSWORD].detail.mdz_textbox.text,
							   [[NSHomeDirectory() stringByAppendingPathComponent:  @"Documents/"] UTF8String]);
	
    // Create anonymous user
	if (settings[FTP_ANONYMOUS].detail.mdz_boolswitch.switch_value) {
		pAnonymousUser = ftpserver->AddUser("anonymous",
                                            NULL,
                                            [[NSHomeDirectory() stringByAppendingPathComponent:  @"Documents/"] UTF8String]);
	}
	
	
    if( pUser ) {
		pUser->SetMaxNumberOfClient( 0 ); // Unlimited
		pUser->SetPrivileges( CFtpServer::READFILE | CFtpServer::WRITEFILE |
							 CFtpServer::LIST | CFtpServer::DELETEFILE | CFtpServer::CREATEDIR |
							 CFtpServer::DELETEDIR );
    }
	if( pAnonymousUser ) pAnonymousUser->SetPrivileges( CFtpServer::READFILE | CFtpServer::WRITEFILE |
													   CFtpServer::LIST | CFtpServer::DELETEFILE | CFtpServer::CREATEDIR |
													   CFtpServer::DELETEDIR );
    if (!ftpserver->StartListening( INADDR_ANY, ftpport )) return false;
    if (!ftpserver->StartAccepting()) return false;
    
    return true;
}

-(void) FTPswitchChanged {
	if (settings[FTP_ONOFF].detail.mdz_switch.switch_value) {
		if ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus]==kReachableViaWiFi) {
			if (!bServerRunning) { // Start the FTP Server
				if ([self startFTPServer]) {
					bServerRunning = true;
					
					NSString *ip = [self getIPAddress];
                    
					NSString *msg = [NSString stringWithFormat:@"Running on %@", ip];
                    if (settings[FTP_STATUS].detail.mdz_msgbox.text) {
                        free(settings[FTP_STATUS].detail.mdz_msgbox.text);
                    }
                    settings[FTP_STATUS].detail.mdz_msgbox.text=(char*)malloc(strlen([msg UTF8String])+1);
                    strcpy(settings[FTP_STATUS].detail.mdz_msgbox.text,[msg UTF8String]);
                    
                    // Disable idle timer to avoid wifi connection lost
                    [UIApplication sharedApplication].idleTimerDisabled=YES;
				} else {
					bServerRunning = false;
					UIAlertView *alert = [[[UIAlertView alloc] initWithTitle: @"Error" message:@"Warning: Unable to start FTP Server." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
					[alert show];
					settings[FTP_ONOFF].detail.mdz_switch.switch_value=0;
				}
			}
			
		} else {
			UIAlertView *alert = [[[UIAlertView alloc] initWithTitle: @"Warning" message:@"FTP server can only run on a WIFI connection." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil] autorelease];
			[alert show];
			settings[FTP_ONOFF].detail.mdz_switch.switch_value=0;
		}
	} else {
		if (bServerRunning) { // Stop FTP server
			// Stop the server
			ftpserver->StopListening();
			// Delete users
			ftpserver->DeleteUser(pAnonymousUser);
			ftpserver->DeleteUser(pUser);
			bServerRunning = false;
            if (settings[FTP_STATUS].detail.mdz_msgbox.text) {
                free(settings[FTP_STATUS].detail.mdz_msgbox.text);
            }
            settings[FTP_STATUS].detail.mdz_msgbox.text=(char*)malloc(strlen("Inactive")+1);
            strcpy(settings[FTP_STATUS].detail.mdz_msgbox.text,"Inactive");
            
            
            // Restart idle timer if battery mode is on (unplugged device)
            if ([[UIDevice currentDevice] batteryState] != UIDeviceBatteryStateUnplugged)
                [UIApplication sharedApplication].idleTimerDisabled=YES;
            else [UIApplication sharedApplication].idleTimerDisabled=NO;
		}
	}
	[tableView reloadData];
}



@end