define processrawcansorfast (filename=!TOKENS(1) /
 sheetname=!TOKENS(1) /
 filetype=!TOKENS(1) /
 CANSorFAST=!TOKENS(1) /
 yyyy=!TOKENS(1) /
 mm=!TOKENS(1) /
 dd=!TOKENS(1) /
 countyname=!TOKENS(1)) 

/* setting the directory in which to pull file and work */
/* check out the FILE HANDLE command */

FILE HANDLE CANSdir /NAME='h:\data_cans'.
FILE HANDLE FASTdir /NAME='h:\data_fast'.

!if (!CANSorFAST='CANS__') !then
/* choose first level of directory */
*cd 'h:/data_cans/'. /* CANS files */
cd CANSdir.
!else
*cd 'h:/data_fast/'. /* FAST files */
cd FASTdir.
!ifend 

/* choose second level of directory */
!if (!countyname='02') !then /* Allegheny county */
cd 'allegh_raw'.
!ifend
!if (!countyname='22') !then /* Dauphin county */
cd 'dauphin_raw'.
!ifend
!if (!countyname='35') !then /* Lackawanna county */
cd 'lacka_raw'.
!ifend
!if (!countyname='51') !then /* Philly county */
cd 'philly_raw'.
!ifend
!if (!countyname='61') !then /* Venango county */
cd 'ven_raw'.
!ifend

/* for the text or csv format files */
!if (!filetype='csv' !or !filetype='txt') !then

!if (!CANSorFAST='CANS__') !then
/* for the CANS file */
get data
 /type=txt
 /file=!concat(!filename,'.',!filetype)
 /delimiters=","
 /importcase=all
 /arrangement=delimited
 /firstcase=2
 /variables=  MCI_ID A10
 ASMT_TYPE F2.0
 ASMT_ID F8.0
 ASMT_DT A12
 ASMT_STATUS F2.0
 DOB A12
 GENDER_ID F2.0
 COUNTY_ID F2.0
 Q_1 F2.0
 Q_2 F2.0
 Q_3 F2.0
 Q_4 F2.0
 Q_5 F2.0
 Q_6 F2.0
 Q_7 F2.0
 Q_8 F2.0
 Q_9 F2.0
 Q_10 F2.0
 Q_11 F2.0
 Q_12 F2.0
 Q_13 F2.0
 Q_14 F2.0
 Q_15 F2.0
 Q_16 F2.0
 Q_17 F2.0
 Q_18 F2.0
 Q_19 F2.0
 Q_20 F2.0
 Q_21 F2.0
 Q_22 F2.0
 Q_23 F2.0
 Q_24 F2.0
 Q_25 F2.0
 Q_26 F2.0
 Q_27 F2.0
 Q_28 F2.0
 Q_29 F2.0
 Q_30 F2.0
 Q_31 F2.0
 Q_32 F2.0
 Q_33 F2.0
 Q_34 F2.0
 Q_35 F2.0
 Q_36 F2.0
 Q_37 F2.0
 Q_38 F2.0
 Q_39 F2.0
 Q_40 F2.0
 Q_41 F2.0
 Q_42 F2.0
 Q_43 F2.0
 Q_44 F2.0
 Q_45 F2.0
 Q_46 F2.0
 Q_47 F2.0
 Q_48 F2.0
 Q_49 F2.0
 Q_50 F2.0
 Q_51 F2.0
 Q_52 F2.0
 Q_53 F2.0
 Q_54 F2.0
 Q_55 F2.0
 Q_56 F2.0
 Q_57 F2.0
 Q_58 F2.0
 Q_59 F2.0
 Q_60 F2.0
 Q_61 F2.0
 Q_62 F2.0
 Q_63 F2.0
 .
!ifend

!if (!CANSorFAST='FASTFT') !then
/* for the Family Together file */
/* for Allegheny county's file name that has a space in it */
/* necessitating putting quotes around it when feeding it */
/* into the macro */
/*  /file=!quote(!concat(!unquote(!filename),'.',!filetype)) */
get data
 /type=txt
 /file=!concat(!filename,'.',!filetype)
 /delimiters=","
 /importcase=all
 /arrangement=delimited
 /firstcase=2
 /variables= FAMILY_ID A10
 ASMT_TYPE F2.0
 ASMT_STATUS F2.0
 ASMT_ID F8.0
 ASMT_DT A12
 COUNTY_ID F2.0
 FT_Q_1 F2.0
 FT_Q_2 F2.0
 FT_Q_3 F2.0
 FT_Q_4 F2.0
 FT_Q_5 F2.0
 FT_Q_6 F2.0
 FT_Q_7 F2.0
 FT_Q_8 F2.0
 FT_Q_9 F2.0
 FT_Q_10 F2.0
 FT_Q_11 F2.0
 .
!ifend

/* will say that the data starts on line 3 */
/* the header is so long that it wraps onto the second line */
!if (!CANSorFAST='FASTCG') !then
/* for the Caregiver file */
get data
 /type=txt
 /file=!concat(!filename,'.',!filetype)
 /delimiters=","
 /importcase=all
 /arrangement=delimited
 /firstcase=3
 /variables=  FAMILY_ID A10
 ASMT_ID F8.0
 CARE_A_ID F10.0
 CARE_A_SA F2.0
 Q_12A F2.0
 Q_13A F2.0
 Q_14A F2.0
 Q_15A F2.0
 Q_16A F2.0
 Q_17A F2.0
 Q_18A F2.0
 Q_19A F2.0
 Q_20A F2.0
 Q_21A F2.0
 Q_22A F2.0
 Q_23A F2.0
 Q_24A F2.0
 Q_A1 F2.0
 Q_A2 F2.0
 Q_A3 F2.0
 Q_A4 F2.0
 Q_A5 F2.0
 Q_A6 F2.0
 Q_A7 F2.0
 Q_A8 F2.0
 Q_A9 F2.0
 Q_A10 F2.0
 CARE_B_ID F10.0
 CARE_B_SA F2.0
 Q_12B F2.0
 Q_13B F2.0
 Q_14B F2.0
 Q_15B F2.0
 Q_16B F2.0
 Q_17B F2.0
 Q_18B F2.0
 Q_19B F2.0
 Q_20B F2.0
 Q_21B F2.0
 Q_22B F2.0
 Q_23B F2.0
 Q_24B F2.0
 Q_B1 F2.0
 Q_B2 F2.0
 Q_B3 F2.0
 Q_B4 F2.0
 Q_B5 F2.0
 Q_B6 F2.0
 Q_B7 F2.0
 Q_B8 F2.0
 Q_B9 F2.0
 Q_B10 F2.0
 CARE_C_ID F10.0
 CARE_C_SA F2.0
 Q_12C F2.0
 Q_13C F2.0
 Q_14C F2.0
 Q_15C F2.0
 Q_16C F2.0
 Q_17C F2.0
 Q_18C F2.0
 Q_19C F2.0
 Q_20C F2.0
 Q_21C F2.0
 Q_22C F2.0
 Q_23C F2.0
 Q_24C F2.0
 Q_C1 F2.0
 Q_C2 F2.0
 Q_C3 F2.0
 Q_C4 F2.0
 Q_C5 F2.0
 Q_C6 F2.0
 Q_C7 F2.0
 Q_C8 F2.0
 Q_C9 F2.0
 Q_C10 F2.0
 CARE_D_ID F10.0
 CARE_D_SA F2.0
 Q_12D F2.0
 Q_13D F2.0
 Q_14D F2.0
 Q_15D F2.0
 Q_16D F2.0
 Q_17D F2.0
 Q_18D F2.0
 Q_19D F2.0
 Q_20D F2.0
 Q_21D F2.0
 Q_22D F2.0
 Q_23D F2.0
 Q_24D F2.0
 Q_D1 F2.0
 Q_D2 F2.0
 Q_D3 F2.0
 Q_D4 F2.0
 Q_D5 F2.0
 Q_D6 F2.0
 Q_D7 F2.0
 Q_D8 F2.0
 Q_D9 F2.0
 Q_D10 F2.0
 CARE_E_ID F10.0
 CARE_E_SA F2.0
 Q_12E F2.0
 Q_13E F2.0
 Q_14E F2.0
 Q_15E F2.0
 Q_16E F2.0
 Q_17E F2.0
 Q_18E F2.0
 Q_19E F2.0
 Q_20E F2.0
 Q_21E F2.0
 Q_22E F2.0
 Q_23E F2.0
 Q_24E F2.0
 Q_E1 F2.0
 Q_E2 F2.0
 Q_E3 F2.0
 Q_E4 F2.0
 Q_E5 F2.0
 Q_E6 F2.0
 Q_E7 F2.0
 Q_E8 F2.0
 Q_E9 F2.0
 Q_E10 F2.0
 CARE_F_ID F10.0
 CARE_F_SA F2.0
 Q_12F F2.0
 Q_13F F2.0
 Q_14F F2.0
 Q_15F F2.0
 Q_16F F2.0
 Q_17F F2.0
 Q_18F F2.0
 Q_19F F2.0
 Q_20F F2.0
 Q_21F F2.0
 Q_22F F2.0
 Q_23F F2.0
 Q_24F F2.0
 Q_F1 F2.0
 Q_F2 F2.0
 Q_F3 F2.0
 Q_F4 F2.0
 Q_F5 F2.0
 Q_F6 F2.0
 Q_F7 F2.0
 Q_F8 F2.0
 Q_F9 F2.0
 Q_F10 F2.0
 CARE_G_ID F10.0
 CARE_G_SA F2.0
 Q_12G F2.0
 Q_13G F2.0
 Q_14G F2.0
 Q_15G F2.0
 Q_16G F2.0
 Q_17G F2.0
 Q_18G F2.0
 Q_19G F2.0
 Q_20G F2.0
 Q_21G F2.0
 Q_22G F2.0
 Q_23G F2.0
 Q_24G F2.0
 Q_G1 F2.0
 Q_G2 F2.0
 Q_G3 F2.0
 Q_G4 F2.0
 Q_G5 F2.0
 Q_G6 F2.0
 Q_G7 F2.0
 Q_G8 F2.0
 Q_G9 F2.0
 Q_G10 F2.0
 CARE_H_ID F10.0
 CARE_H_SA F2.0
 Q_12H F2.0
 Q_13H F2.0
 Q_14H F2.0
 Q_15H F2.0
 Q_16H F2.0
 Q_17H F2.0
 Q_18H F2.0
 Q_19H F2.0
 Q_20H F2.0
 Q_21H F2.0
 Q_22H F2.0
 Q_23H F2.0
 Q_24H F2.0
 Q_H1 F2.0
 Q_H2 F2.0
 Q_H3 F2.0
 Q_H4 F2.0
 Q_H5 F2.0
 Q_H6 F2.0
 Q_H7 F2.0
 Q_H8 F2.0
 Q_H9 F2.0
 Q_H10 F2.0
 CARE_I_ID F10.0
 CARE_I_SA F2.0
 Q_12I F2.0
 Q_13I F2.0
 Q_14I F2.0
 Q_15I F2.0
 Q_16I F2.0
 Q_17I F2.0
 Q_18I F2.0
 Q_19I F2.0
 Q_20I F2.0
 Q_21I F2.0
 Q_22I F2.0
 Q_23I F2.0
 Q_24I F2.0
 Q_I1 F2.0
 Q_I2 F2.0
 Q_I3 F2.0
 Q_I4 F2.0
 Q_I5 F2.0
 Q_I6 F2.0
 Q_I7 F2.0
 Q_I8 F2.0
 Q_I9 F2.0
 Q_I10 F2.0
 CARE_J_ID F10.0
 CARE_J_SA F2.0
 Q_12J F2.0
 Q_13J F2.0
 Q_14J F2.0
 Q_15J F2.0
 Q_16J F2.0
 Q_17J F2.0
 Q_18J F2.0
 Q_19J F2.0
 Q_20J F2.0
 Q_21J F2.0
 Q_22J F2.0
 Q_23J F2.0
 Q_24J F2.0
 Q_J1 F2.0
 Q_J2 F2.0
 Q_J3 F2.0
 Q_J4 F2.0
 Q_J5 F2.0
 Q_J6 F2.0
 Q_J7 F2.0
 Q_J8 F2.0
 Q_J9 F2.0
 Q_J10 F2.0
 .
!ifend

/* will say that the data starts on line 3 */
/* the header is so long that it wraps onto the second line */
!if (!CANSorFAST='FASTCH') !then 
/* for the Child file */
get data
 /type=txt
 /file=!concat(!filename,'.',!filetype)
 /delimiters=","
 /importcase=all
 /arrangement=delimited
 /firstcase=3
 /variables=  FAMILY_ID A10
  ASMT_ID F8.0
 CHILD_A_MCI A10
 CHILD_A_DOB A12
 CHILD_A_GEN F2.0
 Q_25A F2.0
 Q_26A F2.0
 Q_27A F2.0
 Q_28A F2.0
 Q_29A F2.0
 Q_30A F2.0
 Q_31A F2.0
 Q_32A F2.0
 Q_33A F2.0
 Q_34A F2.0
 Q_35A F2.0
 CHILD_B_MCI A10
 CHILD_B_DOB A12
 CHILD_B_GEN F2.0
 Q_25B F2.0
 Q_26B F2.0
 Q_27B F2.0
 Q_28B F2.0
 Q_29B F2.0
 Q_30B F2.0
 Q_31B F2.0
 Q_32B F2.0
 Q_33B F2.0
 Q_34B F2.0
 Q_35B F2.0
 CHILD_C_MCI A10
 CHILD_C_DOB A12
 CHILD_C_GEN F2.0
 Q_25C F2.0
 Q_26C F2.0
 Q_27C F2.0
 Q_28C F2.0
 Q_29C F2.0
 Q_30C F2.0
 Q_31C F2.0
 Q_32C F2.0
 Q_33C F2.0
 Q_34C F2.0
 Q_35C F2.0
 CHILD_D_MCI A10
 CHILD_D_DOB A12
 CHILD_D_GEN F2.0
 Q_25D F2.0
 Q_26D F2.0
 Q_27D F2.0
 Q_28D F2.0
 Q_29D F2.0
 Q_30D F2.0
 Q_31D F2.0
 Q_32D F2.0
 Q_33D F2.0
 Q_34D F2.0
 Q_35D F2.0
 CHILD_E_MCI A10
 CHILD_E_DOB A12
 CHILD_E_GEN F2.0
 Q_25E F2.0
 Q_26E F2.0
 Q_27E F2.0
 Q_28E F2.0
 Q_29E F2.0
 Q_30E F2.0
 Q_31E F2.0
 Q_32E F2.0
 Q_33E F2.0
 Q_34E F2.0
 Q_35E F2.0
 CHILD_F_MCI A10
 CHILD_F_DOB A12
 CHILD_F_GEN F2.0
 Q_25F F2.0
 Q_26F F2.0
 Q_27F F2.0
 Q_28F F2.0
 Q_29F F2.0
 Q_30F F2.0
 Q_31F F2.0
 Q_32F F2.0
 Q_33F F2.0
 Q_34F F2.0
 Q_35F F2.0
 CHILD_G_MCI A10
 CHILD_G_DOB A12
 CHILD_G_GEN F2.0
 Q_25G F2.0
 Q_26G F2.0
 Q_27G F2.0
 Q_28G F2.0
 Q_29G F2.0
 Q_30G F2.0
 Q_31G F2.0
 Q_32G F2.0
 Q_33G F2.0
 Q_34G F2.0
 Q_35G F2.0
 CHILD_H_MCI A10
 CHILD_H_DOB A12
 CHILD_H_GEN F2.0
 Q_25H F2.0
 Q_26H F2.0
 Q_27H F2.0
 Q_28H F2.0
 Q_29H F2.0
 Q_30H F2.0
 Q_31H F2.0
 Q_32H F2.0
 Q_33H F2.0
 Q_34H F2.0
 Q_35H F2.0
 CHILD_I_MCI A10
 CHILD_I_DOB A12
 CHILD_I_GEN F2.0
 Q_25I F2.0
 Q_26I F2.0
 Q_27I F2.0
 Q_28I F2.0
 Q_29I F2.0
 Q_30I F2.0
 Q_31I F2.0
 Q_32I F2.0
 Q_33I F2.0
 Q_34I F2.0
 Q_35I F2.0
 CHILD_J_MCI A10
 CHILD_J_DOB A12
 CHILD_J_GEN F2.0
 Q_25J F2.0
 Q_26J F2.0
 Q_27J F2.0
 Q_28J F2.0
 Q_29J F2.0
 Q_30J F2.0
 Q_31J F2.0
 Q_32J F2.0
 Q_33J F2.0
 Q_34J F2.0
 Q_35J F2.0
 .
!ifend


/* close for the txt or csv format files */
!ifend



/* for the xls or xlsx format files */
!if (!filetype='xls' !or !filetype='xlsx') !then

get data
 /type=!filetype
 /file=!concat(!filename,'.',!filetype)
 /sheet=name !sheetname
 /cellrange=full
 /readnames=on.
 
/* close for the xls or xlsx format files */
!ifend

*string filedate (A8).
*execute.
*COMPUTE filedate=!concat(!yyyy,!mm,!dd).
COMPUTE filedate=!yyyy*10000+!mm*100+!dd.
COMPUTE countycode=!countyname.
COMPUTE rownum=$casenum.

/* set the directory of where to save the file */
/* don't seem to have a way to move up one level in directory */
!if (!CANSorFAST='CANS__') !then

/* choose first level of directory */
*cd 'h:/data_cans/'. /* CANS files */
cd CANSdir.
!else
*cd 'h:/data_fast/'. /* FAST files */
cd FASTdir.
!ifend

/* choose second level of directory */
!if (!countyname='02') !then /* Allegheny county */
cd 'allegh_processed'.
!ifend
!if (!countyname='22') !then /* Dauphin county */
cd 'dauphin_processed'.
!ifend
!if (!countyname='35') !then /* Lackawanna county */
cd 'lacka_processed'.
!ifend
!if (!countyname='51') !then /* Philly county */
cd 'philly_processed'.
!ifend
!if (!countyname='61') !then /* Venango county */
cd 'ven_processed'.
!ifend



save outfile=!quote(!concat(!yyyy,!mm,!dd,'_',!countyname,'_',!CANSorFAST,'_processed.sav')).

!enddefine.

set mprint yes.