//+------------------------------------------------------------------+
//|                                              FirstRobot_base.mq5 |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include  <Trade_Func004.mqh>


sinput int Magic_num = 342;
sinput char inPrintfl = 0;
sinput double inLot = 1;
//sinput int day_shift = 0;


input int inSLmin = 25;
input int inSLmax = 80;
input int inSLadd = 10;
input int inSL = 30;
input int inTP = 450;
input int inTPmax = 800;
input int inMinBoxSize = 30;
input int inSLTPlim = 0;
input bool inSLbyChanal = false;
                
input bool inATRedSLTP = false;
input bool inRelatedKooef = true;
//input bool inInnerSLbarfl = true;
input int inATRcntVal = 14;
input int inATRusageVal = 1;
//input int inSLTPcntBias = 2;
//input double inATRusegeK = 1; // 0.5 - 1

input double inATR_TPk = 0.5;
//0.5 - 3

input double inATR_SLk = 0.05;
//TP/10

input double inATR_BUpk = 0.1;
//SL*2

input double inATR_BUmk = 1;
// меньше SL

input double inATR_BUtpk = 1;
// меньше БУ-
input double inATR_BUtpProfk = 1;

input double inATR_CansLk = 1;
input double inATR_RCansLk = 1;

input bool inFloatSize = true;
input bool inFloatSizeCh = true;
input int inFloatSizeChLim = 6;
input int inBoxSize = 36;

input bool inBigBarfl = true;
input double inBBKoefMul = 1.7;


//input bool inBigBarFDfl = true;
//input double inBBFDKoefMul = 1.7;
input bool inBigDayfl = true;
input double inBigDayKoef = 2;
input bool inBigDayTradefl = true;
//input bool inBigDayDirfl = false;
//input char inBigDayDir = 0;

input bool inBUplusfl = true;
input bool inBUminusfl = true;
input bool inTrlSLfl = true;
input bool inMoveTPBUfl = true;

input int inBUplusVal = 40;
input int inBUminusVal = 25;
input int inBUadd = 3;

input int inTPBUval = 20;
input int inTPBUprof = 20;
//input double inTPBUkoef = 2;

//input double inBUminusoKoef = 0.7;

input int inTrlSLstep = 0;
input int inTrlSLstepLvl = 0;
//input int inSLcancelMul = 2;

input int inPosTimeLim = 0;
input double inLimKoef = 2;

input int inCansLVL = 150;
input int inRevCansLVL = 150;

input char inDirTrade = 4; 
//0x4 - пробой, 0х2 - отскок, 0х1 - торговля во вне ВБ
//input bool inProboyfl = true;
//input bool inOtskokfl = false;
//input bool inOutOfBarfl = false;

input bool inVolfl = false;

input char inReversePositionfl = 0;
//input bool inReverseIfSL = false;
//input bool inReverseIfBUplus = false;
//input bool inReverseIfBUminus = false;

input int inQu_of_Reverse_a_Trade= 0;
input int inQu_of_Trade_a_Period= 2;
input char ReverseBar_Exp_cnt = 60;
input char InnerBar_Exp_cnt = 60;
input bool in1mTradePeriod = true;
//input bool inDopTradePeriod = true;
input uchar inTradePeriodCNT = 6;
input bool inCloseForNightfl = false;
input double inCloseForNightKoef = 2;
input bool inCloseForWeekendfl = true;
//input char inCloseForContrChngfl = 0;
input char inClzForContrChange = 0;
input bool inClzForWar = false;
input uint inMoveSLTPfl = 12;

//input bool inADXusage = true;
//int ADXhandle;
//input int ADXperiod = 14;

//sinput int Magic_num = 345;
//sinput double inLot = 1;
//input int inSL = 560;
//input int inTP = 9200;
//input bool inBUplusfl = true;
//input bool inTrlSLfl = true;
//input int inBUplusVal = 600;
//input int inTrlSLstep = 3500;
//input int inTrlSLstepLvl = 500;
//input int inCansLVL = 2000;
//input bool inProboyfl = true;
//input bool inOtskokfl = false;
//input bool inVolfl = false;
//input bool inReversePositionfl = false;
//input int inQu_of_Reverse_a_Trade= 0;
//input int inQu_of_Trade_a_Period= 3;
//input bool in1mTradePeriod = false;

//input string inStartTradingTime = "00:05";
//input string inStopTradingTime = "21:00";
input ushort inStartTradingTimeU = 0;
input ushort inStopTradingTimeU = 0;
//input ushort inStartForbiddenTimeU = 0;
//input ushort inStopForbiddenTimeU = 0;
sinput int inFiltr = 50;
sinput int Slipage = 10;
input int inLuft = 0;
sinput double OutComission = 0;

input bool isDayMonAllowed = true;
input bool isDayTueAllowed = true;
input bool isDayWenAllowed = true;
input bool isDayThuAllowed = true;
input bool isDayFriAllowed = true;

static  int CurSL = 0;
static  int CurTP = 0;
static  int SLintegrator = 0;
static  int TPintegrator = 0;

static  int CurCansLVL = 0;
static  int CurRevCansLVL = 0;


static bool BUplusfl = inBUplusfl;
static bool BUminusfl = inBUminusfl;
static bool MoveTPBUfl = inMoveTPBUfl;
static int CurTPBUval = inTPBUval;
static int CurTPBUprof = inTPBUprof;

static   int CurBUplus = 0;
static   int CurBUminus = 0;
//int BUlvl = inBUval;//inSL * inBUmul;
static   char BUtrigedfl = 0;

static int PosTimeLim = 0;

static   datetime t = 0;
static   datetime t_m = 0;
static   datetime t_p = 0;

static   datetime t_d = 0;

static   int CurBoxSize = 0;

static   MqlDateTime CurPeriod_Date = {};
static   MqlDateTime CurTick_Date = {};
static   double High_lvl = 0;
static   double CurPeriod_High_lvl = 0;
static   double CurPeriod_High_lvl_prev = 0;
 static  double Low_lvl = 0;
 static  double CurPeriod_Low_lvl = 0;
 static  double CurPeriod_Low_lvl_prev = 0;
 static  double CurPeriod_Aver_lvl = 0;
 static  double CurPeriod_Aver_lvl_prev = 0;

static   char IsLvlToched = 0;
 static  char IsTradeSituationChosen = 0;
 static  char IsDirChosen = 0;
 static  char TradeSignalfl = 0;
 static  char TradeSignalModfl = 0;

 static  char BigDaySigfl = 0;
static   double BigDayD1 = 0;
static   double BigDayD2 = 0;
static   double BigDayD3 = 0;
static  char BigDayTrend1 = 0;
static  char BigDayTrend2 = 0;

static   char IsDirTradefl = inDirTrade;
//  bool IsProboyfl = inProboyfl;
//  bool IsOtskokfl = inOtskokfl;
//  bool IsOutOfBarfl = inOutOfBarfl;
//  datetime minute_value = 0;

static   char InnerBar_signal = 0;
static   datetime InnerBar_signal_TimeSt = 0;
static   double CurPeriod_Trade_lvl = 0;
static   double CurPeriod_Ref_lvl = 0;
static   double CurPeriod_Stop_lvl = 0;
static   double CurPeriod_Cancel_lvl_H = 0;

static   double CurPeriod_Cancel_lvl_L = 0;

 static  double CurPeriod_CancelRev_lvl_H = 0;
static   double CurPeriod_CancelRev_lvl_L = 0;
 static  double CurPeriod_tmp = 0;



static   bool TrlSLfl = inTrlSLfl;
static   int TrlSLlvl = 0;
static double LastSL = 0;
static double Symb_Point = 0;
static  int Symb_digit = 0;

static bool isOrderPlacedfl = false;
static char isPositionOpenfl = 0;
static bool isRevPosAllowfl = false;
static ulong CurPositionID = 0;
static int Trade_a_Period_Quantity = inQu_of_Trade_a_Period;
static int Reverse_a_Period_Quantity = inQu_of_Reverse_a_Trade;

static   double CurLvl_width = 0;
//struct trdlvl {double price; char width; datetime formtime;};

static double ATR_D = 0;

static double ATR_5 = 0;
static double ATR_10 = 0;
static double ATR_15 = 0;
static double ATR_30 = 0;
static double ATR_60 = 0;
static double ATR_120 = 0;
static double ATR_240 = 0;
static double ATR_360 = 0;
static double ATR_480 = 0;
static double ATR_720 = 0;
input static int inATR_m_cntval = 10;


//const uint TradeLVLsize = 6;
//#define TradeLVLsize 6


//trdlvl TradeLVL [TradeLVLsize];

//struct trdlvl2*  CurTrdLvl ;//= TradeLVL[0];


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   if(ObjectsTotal(0,0,-1))
      ObjectsDeleteAll(0,0,-1);
      
    //if(inADXusage)  {
    //     ADXhandle = iADX(_Symbol,PERIOD_CURRENT,ADXperiod);   
    //     if(ADXhandle == INVALID_HANDLE){
    //           Print("ошибка хендла индикатора");
    //     }
    //}
   t_p = 0;
   t_m = 0;
   t_d = 0;

   SLintegrator = inSL;
   TPintegrator = inTP;
   CurSL = SLintegrator;
   CurTP = TPintegrator;
   CurBoxSize = inBoxSize;
   if(inRelatedKooef){
   
           CurBUplus = (int)(CurSL * inATR_BUpk);
                  Print("текущий CurBUplus: ", CurBUplus);
                  
           CurBUminus =(int)(CurSL * inATR_BUmk);
                  Print("текущий CurBUminus: ", CurBUminus);
           CurTPBUval = (int)((CurSL - CurBUminus) * inATR_BUtpk);
                  Print("текущий CurTPBUval: ", CurTPBUval);
           CurTPBUprof = (int)(CurTP * inATR_BUtpProfk);
                  Print("текущий CurTPBUprof: ", CurTPBUprof);
           CurCansLVL = (int)(CurSL * inATR_CansLk);
                  Print("текущий CurCansLVL: ", CurCansLVL);
                  
           CurRevCansLVL = (int)(CurSL * inATR_RCansLk);
           if(!CurRevCansLVL) CurRevCansLVL = CurCansLVL ;
                  Print("текущий CurRevCansLVL: ", CurCansLVL);
               
   }
   else{
      
      CurBUplus = inBUplusVal;
      CurBUminus = inBUminusVal;
      CurTPBUval = inTPBUval;
      CurTPBUprof = inTPBUprof;
      CurCansLVL = inCansLVL;
      CurRevCansLVL = inRevCansLVL;
   }
   if(inCansLVL){
   	CurCansLVL = inCansLVL;
   	if(!inRevCansLVL){
   		CurRevCansLVL = CurCansLVL;
   	}
   }
   
//minute_value = iTime(NULL,PERIOD_M1,1) - iTime(NULL,PERIOD_M1,2)  ;
   isPositionOpenfl = 0;
   Symb_Point = SymbolInfoDouble(_Symbol,SYMBOL_POINT);
   Symb_digit = (int)SymbolInfoInteger(_Symbol,SYMBOL_DIGITS);
   InnerBar_signal = 0;
   BigDaySigfl = 0;
   CurPeriod_High_lvl = 0;
   CurPeriod_Low_lvl = 0;
   
   double CandleSizeSum_ = 0;
    
//      for(int n = 0; n < inATR_m_cntval; n++){
//           CandleSizeSum_ += iHigh(NULL,PERIOD_M5,n) - iLow(NULL,PERIOD_M5,n);       
//      }
//      ATR_5 = (CandleSizeSum_/inATR_m_cntval)/ Symb_Point;
//      
//      CandleSizeSum_ = 0;      
//
//      for(int n = 0; n < inATR_m_cntval; n++){
//           CandleSizeSum_ += iHigh(NULL,PERIOD_M10,n) - iLow(NULL,PERIOD_M10,n);       
//      }
//      ATR_10 = (CandleSizeSum_/inATR_m_cntval)/ Symb_Point;
//      
//      CandleSizeSum_ = 0;      
//
//      for(int n = 0; n < inATR_m_cntval; n++){
//           CandleSizeSum_ += iHigh(NULL,PERIOD_M15,n) - iLow(NULL,PERIOD_M15,n);       
//      }
//      ATR_15 = (CandleSizeSum_/inATR_m_cntval)/ Symb_Point; 
// 
//      CandleSizeSum_ = 0;      
//
//      for(int n = 0; n < inATR_m_cntval; n++){
//           CandleSizeSum_ += iHigh(NULL,PERIOD_M30,n) - iLow(NULL,PERIOD_M30,n);       
//      }
//      ATR_30 = (CandleSizeSum_/inATR_m_cntval)/ Symb_Point;
//       
//      CandleSizeSum_ = 0;      
//
//      for(int n = 0; n < inATR_m_cntval; n++){
//           CandleSizeSum_ += iHigh(NULL,PERIOD_H1,n) - iLow(NULL,PERIOD_H1,n);       
//      }
//      ATR_60 = (CandleSizeSum_/inATR_m_cntval)/ Symb_Point;
//      
//      CandleSizeSum_ = 0;      
//
//      for(int n = 0; n < inATR_m_cntval; n++){
//           CandleSizeSum_ += iHigh(NULL,PERIOD_H2,n) - iLow(NULL,PERIOD_H2,n);       
//      }
//      ATR_120 = (CandleSizeSum_/inATR_m_cntval)/ Symb_Point;
//      
//      CandleSizeSum_ = 0;      
//
//      for(int n = 0; n < inATR_m_cntval; n++){
//           CandleSizeSum_ += iHigh(NULL,PERIOD_H4,n) - iLow(NULL,PERIOD_H4,n);       
//      }
//      ATR_240 = (CandleSizeSum_/inATR_m_cntval)/ Symb_Point;       
//      
//      CandleSizeSum_ = 0;      
//
//      for(int n = 0; n < inATR_m_cntval; n++){
//           CandleSizeSum_ += iHigh(NULL,PERIOD_H6,n) - iLow(NULL,PERIOD_H6,n);       
//      }
//      ATR_360 = (CandleSizeSum_/inATR_m_cntval)/ Symb_Point;
//      
//           CandleSizeSum_ = 0;      
//
//      for(int n = 0; n < inATR_m_cntval; n++){
//           CandleSizeSum_ += iHigh(NULL,PERIOD_H8,n) - iLow(NULL,PERIOD_H8,n);       
//      }
//      ATR_480 = (CandleSizeSum_/inATR_m_cntval)/ Symb_Point;
//      
//      CandleSizeSum_ = 0;      
//
//     
//      for(int n = 0; n < inATR_m_cntval; n++){
//           CandleSizeSum_ += iHigh(NULL,PERIOD_H12,n) - iLow(NULL,PERIOD_H12,n);       
//      }
//      ATR_720 = (CandleSizeSum_/inATR_m_cntval)/ Symb_Point;                         
 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
// int r = 288;
 
//char findLocalExtr(int l){
//   char res = 0;
//   if(iHigh(NULL,PERIOD_M5,l) < iHigh(NULL,PERIOD_M5,l+1)) res |= 0x1;
//   if(iLow(NULL,PERIOD_M5,l) > iLow(NULL,PERIOD_M5,l+1)) res |= 0x2;
//
//   if(res == 1) return 1;
//   if(res == 2) return -1;
//   if((res == 3)||(res == 0)) return 0;
//   
//} 

//   char dirsign = 0;
//for (int j=1; j < r; j++){
//   char dirsignPrev = dirsign;
//   dirsign = findLocalExtr(j);
//   if(dirsign){
//      if(dirsign == dirsignPrev) continue;
//      else{}
//      
//   
//   }
//
//} 
   
 
      int k =0;
      
      for(k=0;k < InnerBar_Exp_cnt;k++)
      //if(t_p != iTime(NULL,PERIOD_CURRENT,0))  //+ ((in1mTradePeriod)? (minute_value*3) :(minute_value*15))
        {
         t_p = iTime(NULL,PERIOD_CURRENT,0+k ) ; //+ ((in1mTradePeriod)? (minute_value*3) :(minute_value*15))
         //if(ObjectsTotal(0,0,-1)) ObjectsDeleteAll(0,0,-1);
         //CloseAllPositionsBySymb(_Symbol);
         //TimeToStruct(t_p, CurPeriod_Date);

         double LastCandlH = 0;
         double LastCandlL = 0;
         double PrevLstCandlH = 0;
         double PrevLstCandlL = 0;

         if(inFloatSize)
           {
            LastCandlH = iHigh(NULL,PERIOD_CURRENT,iHighest(NULL,PERIOD_CURRENT,MODE_HIGH,CurBoxSize,1+k));
            LastCandlL = iLow(NULL,PERIOD_CURRENT,iLowest(NULL,PERIOD_CURRENT,MODE_LOW,CurBoxSize,1+k));
            PrevLstCandlH = iHigh(NULL,PERIOD_CURRENT,iHighest(NULL,PERIOD_CURRENT,MODE_HIGH,CurBoxSize,1+CurBoxSize+k));
            PrevLstCandlL = iLow(NULL,PERIOD_CURRENT,iLowest(NULL,PERIOD_CURRENT,MODE_LOW,CurBoxSize,1+CurBoxSize+k));
           }
         else
           {
            LastCandlH = iHigh(NULL,PERIOD_CURRENT,1+k);
            LastCandlL = iLow(NULL,PERIOD_CURRENT,1+k);
            PrevLstCandlH = iHigh(NULL,PERIOD_CURRENT,2+k);
            PrevLstCandlL = iLow(NULL,PERIOD_CURRENT,2+k);
           }

           //    ObjectCreate(0,"Last_Rect",OBJ_RECTANGLE,0+k,
           //                 iTime(NULL,PERIOD_CURRENT,CurBoxSize+k),LastCandlH,
           //                 iTime(NULL,PERIOD_CURRENT,1+k),LastCandlL);
           //    ObjectCreate(0,"Prev_Rect",OBJ_RECTANGLE,0+k,
           //                 iTime(NULL,PERIOD_CURRENT,CurBoxSize+CurBoxSize+k),PrevLstCandlH,
           //                 iTime(NULL,PERIOD_CURRENT,CurBoxSize+1+k),PrevLstCandlL);
           //ChartRedraw();

         if(
            (NormalizeDouble(LastCandlH,Symb_digit) < NormalizeDouble(PrevLstCandlH,Symb_digit)) &&
            (NormalizeDouble(LastCandlL,Symb_digit) > NormalizeDouble(PrevLstCandlL,Symb_digit)) &&
            (inVolfl?
             //((inVolfl)?(iVolume(NULL,PERIOD_CURRENT,1) > iVolume(NULL,PERIOD_CURRENT,2)):true) ||
             (iVolume(NULL,PERIOD_CURRENT,1+k) > iVolume(NULL,PERIOD_CURRENT,2+k))
             :true
            ) &&
            (inBigBarfl?
             ((LastCandlH - LastCandlL)*inBBKoefMul < (PrevLstCandlH - PrevLstCandlL))
             :true
            )

         )
           {
            //if(!isPositionOpenfl)
            //  {
               //IsLvlToched = 0;   ??????????????????????
               Reverse_a_Period_Quantity = inQu_of_Reverse_a_Trade;
               CurPeriod_Trade_lvl = 0;
               CurPeriod_Ref_lvl = 0;
               LastSL = 0;
              //}
            IsLvlToched = 0;
            IsTradeSituationChosen = 0;
            CurPeriod_High_lvl = 0;
            CurPeriod_Low_lvl = 0;
            IsDirTradefl = inDirTrade;
            //IsProboyfl = inProboyfl;
            //IsOtskokfl = inOtskokfl;
            //IsOutOfBarfl = inOutOfBarfl;
            Trade_a_Period_Quantity = inQu_of_Trade_a_Period;



            CurPeriod_High_lvl = NormalizeDouble(LastCandlH,Symb_digit);


            CurPeriod_Low_lvl = NormalizeDouble(LastCandlL,Symb_digit);

            CurPeriod_Aver_lvl = NormalizeDouble(((CurPeriod_High_lvl + CurPeriod_Low_lvl)/2),Symb_digit);
            if(inFloatSize)
              {
               ObjectCreate(0,"Last_Rect",OBJ_RECTANGLE,0+k,
                            iTime(NULL,PERIOD_CURRENT,CurBoxSize+k),LastCandlH,
                            iTime(NULL,PERIOD_CURRENT,1+k),LastCandlL);
               ObjectCreate(0,"Prev_Rect",OBJ_RECTANGLE,0+k,
                            iTime(NULL,PERIOD_CURRENT,CurBoxSize+CurBoxSize+k),PrevLstCandlH,
                            iTime(NULL,PERIOD_CURRENT,CurBoxSize+1+k),PrevLstCandlL);
               ObjectCreate(0,"HorH_Line",OBJ_HLINE,0+k,t_p,CurPeriod_High_lvl);
               ObjectCreate(0,"HorL_Line",OBJ_HLINE,0+k,t_p,CurPeriod_Low_lvl);

              }
            else
              {
               ObjectCreate(0,"HorH_Line",OBJ_HLINE,0+k,t_p,CurPeriod_High_lvl);
               ObjectCreate(0,"HorL_Line",OBJ_HLINE,0+k,t_p,CurPeriod_Low_lvl);
               ObjectCreate(0,"Vert_line",OBJ_VLINE,0+k,iTime(NULL,PERIOD_CURRENT,2+k),LastCandlH);
              }
            //AddLVLs_toStr(CurPeriod_High_lvl,CurPeriod_Low_lvl,t_p);
            //AddLVLaver_toStr(CurPeriod_Aver_lvl,LVL_width,t_p);
            ChartRedraw();
            Print("Внутренний бар найден, CurPeriod_High_lvl = ", CurPeriod_High_lvl,", CurPeriod_Low_lvl = ", CurPeriod_Low_lvl);
            Print("Внутренний бар найден, k= ",k);
            InnerBar_signal = 1;
            InnerBar_signal_TimeSt = t_p;
            break;

           } //if внутреннтй бар
           
        }// for (t_p != iTime(NULL,PERIOD_CURRENT,0+k) )
        
        
       int k_d = 0;
       
       while(iTime(NULL,PERIOD_CURRENT,k) < iTime(NULL,PERIOD_D1,k_d)){
            k_d++;
       }
     
     
                 if(t_d != iTime(NULL,PERIOD_D1,k_d))    //+ ((in1mTradePeriod)? (minute_value*3) :(minute_value*15))
            {
                   t_d = iTime(NULL,PERIOD_D1,k_d);
               
                   double CandleSizeSum = 0;
                   ATR_D = 0;
                  for(int i = 1+k_d; i<= inATRcntVal+k_d; i++)
                    {
         
                     CandleSizeSum += iHigh(NULL,PERIOD_D1,i) - iLow(NULL,PERIOD_D1,i);
         
                    }
                  ATR_D = (CandleSizeSum/inATRcntVal)/ Symb_Point;
                  
         if(inBigDayfl)
              {
              
               if(BigDayD1>0)
                 {BigDayD2 = BigDayD1;}
               else
                 {
                  BigDayD2 = iHigh(NULL,PERIOD_D1,2+k_d) - iLow(NULL,PERIOD_D1,2+k_d);
                  if(iOpen(NULL,PERIOD_D1,2+k_d) > iClose(NULL,PERIOD_D1,2+k_d))
                    {BigDayD2 *= -1;}
                 }
               BigDayD1 = iHigh(NULL,PERIOD_D1,1+k_d) - iLow(NULL,PERIOD_D1,1+k_d);
               if(iOpen(NULL,PERIOD_D1,1+k_d) > iClose(NULL,PERIOD_D1,1+k_d))
                 {BigDayD1 *= -1;}
               
               BigDayTrend2 = BigDayTrend1;
               
               //  if((ATR_D*inBigDayKoef) > (BigDayD1))
               if((MathAbs(BigDayD1 * inBigDayKoef) < MathAbs(BigDayD2)) //&&
                  //(MathAbs(BigDayD2 * inBigDayKoef) < MathAbs(BigDayD3)) &&
                  //(inBigDayDirfl?(((BigDayD1 * BigDayD2) > 0)/*&&((BigDayD1 * BigDayD3) > 0)*/):true)
                  )
                 {
                  BigDaySigfl = (BigDayD1>0)?1:-1;
                  BigDayTrend1 = -1;
                  }
   
               else{
                  BigDaySigfl = 0;
                  BigDayTrend1 = 1;
               }
              }// if(inBigDayfl)
              
           if(inATRedSLTP)
                    {
                     Print("текущий Символ: ", _Symbol);
                     int ATRi = (int)(ATR_D);
                     Print("текущий АТR_D: ",ATRi);
                     CurSL = (int)(ATRi * inATR_SLk);
                     CurSL = (int)((CurSL*inATRusageVal + inSL)/ (1+inATRusageVal));
                     if(inSLmin && (CurSL < inSLmin)) CurSL = inSLmin;
                     Print("текущий SL: ", CurSL);
                     
                     CurTP = (int)(ATRi * inATR_TPk);
                     CurTP = (int)((CurTP*inATRusageVal + inTP)/(1+inATRusageVal));
                     Print("текущий TP: ", CurTP);
                     
                     CurBUplus = (int)(CurSL * inATR_BUpk);
                     Print("текущий CurBUplus: ", CurBUplus);
                     
                     CurBUminus =(int)(CurSL * inATR_BUmk);
                     Print("текущий CurBUminus: ", CurBUminus);
                     CurTPBUval = (int)((CurSL - CurBUminus) * inATR_BUtpk);
                     Print("текущий CurTPBUval: ", CurTPBUval);
                     CurTPBUprof = (int)(CurTP * inATR_BUtpProfk);
                     Print("текущий CurTPBUprof: ", CurTPBUprof);
                     Print("текущий CurCansLVL: ", CurCansLVL);
                     //CurCansLVL = (int)(CurSL * inATR_CansLk);
                     //CurRevCansLVL = (int)(CurSL * inATR_RCansLk);
                     if(Symb_Point == 1)
                       {
                        CurTP /= 10;
                        CurSL /= 10;
                        CurBUplus /= 10;
                        CurBUminus /= 10;
                        CurTPBUval  /= 10;
                        CurTPBUprof  /= 10;
                        //CurCansLVL  /= 10;
                       // CurRevCansLVL  /= 10;

                       
         
                        CurTP *= 10;
                        CurSL *= 10;
                        CurBUplus *= 10;
                        CurBUminus *= 10;
                        CurTPBUval  *= 10;
                        CurTPBUprof  *= 10;
                        //CurCansLVL *= 10;
                       // CurRevCansLVL  *= 10;
                       }
      
                 } //if(inATRedSLTP)
                     
               
            }// t_d     
        
          //Print("текущий АТR_5: ",ATR_5);
          //Print("текущий ATR_10: ",ATR_10);        
          //Print("текущий ATR_15: ",ATR_15);
          //Print("текущий ATR_30: ",ATR_30);
          //Print("текущий ATR_60: ",ATR_60);
          //Print("текущий ATR_120: ",ATR_120);
          //Print("текущий ATR_240: ",ATR_240);
          //Print("текущий ATR_360: ",ATR_360);
          //Print("текущий ATR_480: ",ATR_480);
          //Print("текущий ATR_720: ",ATR_720);
        
   //  k++; /////????/

       if(InnerBar_signal){
         Print("начало поиска касания, k= ",k);
        while(k>0){
              
                      Print("поиск касания, k= ",k);
         if(InnerBar_signal && !IsLvlToched)
           {

         // if((t_m - InnerBar_signal_TimeSt) > (PeriodSeconds(in1mTradePeriod?PERIOD_M1:PERIOD_M5)*(inTradePeriodCNT+1))) //(inDopTradePeriod?4:3)
         // {
         double TrgCandleH = NormalizeDouble(iHigh(NULL,in1mTradePeriod?PERIOD_M1:PERIOD_M5,2+k),Symb_digit);
         double TrgCandleL = NormalizeDouble( iLow(NULL,in1mTradePeriod?PERIOD_M1:PERIOD_M5,2+k),Symb_digit);
         double TrgCandleO = NormalizeDouble(iOpen(NULL,in1mTradePeriod?PERIOD_M1:PERIOD_M5,2+k),Symb_digit);

         if((TrgCandleH >= CurPeriod_High_lvl)&&(CurPeriod_High_lvl >= TrgCandleL))
           {
            CurPeriod_Trade_lvl = CurPeriod_High_lvl;
            Print("текущий CurPeriod_Trade_lvl(H): ", CurPeriod_Trade_lvl);
            CurPeriod_Ref_lvl = CurPeriod_Low_lvl;
            
            CurPeriod_Cancel_lvl_H = CurPeriod_High_lvl + (CurCansLVL*Symb_Point);
            //Print("текущий CurPeriod_Cancel_lvl_H: ", CurPeriod_Cancel_lvl_H);
            
            CurPeriod_Cancel_lvl_L = CurPeriod_High_lvl - (CurCansLVL*Symb_Point);
            //Print("текущий CurPeriod_Cancel_lvl_L: ", CurPeriod_Cancel_lvl_L);
            
            CurPeriod_CancelRev_lvl_H = CurPeriod_Trade_lvl + (CurRevCansLVL *Symb_Point);
            CurPeriod_CancelRev_lvl_L = CurPeriod_Trade_lvl - (CurRevCansLVL *Symb_Point);


            if(TrgCandleO < CurPeriod_Trade_lvl)
               IsLvlToched = 1;
               //break;
            else
              {
               if(TrgCandleO > CurPeriod_Trade_lvl)
                  IsLvlToched = -1;
                  //break;
               else
                  IsLvlToched = 0;
              }
           }
         // else{
         if((TrgCandleH >= CurPeriod_Low_lvl)&&(CurPeriod_Low_lvl >= TrgCandleL))
           {
            if(IsLvlToched)
              {
               IsLvlToched = 0;
              }
            else
              {
               // if(!((TrgCandleH < CurPeriod_High_lvl)&&(CurPeriod_High_lvl > TrgCandleL)))
               CurPeriod_Trade_lvl = CurPeriod_Low_lvl;
               Print("текущий CurPeriod_Trade_lvl(L): ", CurPeriod_Trade_lvl);
               CurPeriod_Ref_lvl = CurPeriod_High_lvl;
               
               CurPeriod_Cancel_lvl_H = CurPeriod_Low_lvl + (CurCansLVL*Symb_Point);
               //Print("текущий CurPeriod_Cancel_lvl_H: ", CurPeriod_Cancel_lvl_H);
               
               CurPeriod_Cancel_lvl_L = CurPeriod_Low_lvl - (CurCansLVL*Symb_Point);
               //Print("текущий CurPeriod_Cancel_lvl_L: ", CurPeriod_Cancel_lvl_L);

               CurPeriod_CancelRev_lvl_H = CurPeriod_Trade_lvl + CurRevCansLVL *Symb_Point;
               CurPeriod_CancelRev_lvl_L = CurPeriod_Trade_lvl - CurRevCansLVL *Symb_Point;
   
               if(TrgCandleO < CurPeriod_Trade_lvl)
                  IsLvlToched = 1;
                  //break;
               else
                 {
                  if(TrgCandleO > CurPeriod_Trade_lvl)
                     IsLvlToched = -1;
                     //break;
                  else
                     IsLvlToched = 0;
                 }
              }

           }

           }//  if(InnerBar_signal && !IsLvlToched))
           
               double LastCandleH = NormalizeDouble(iHigh(NULL,in1mTradePeriod?PERIOD_M1:PERIOD_M5,1+k),Symb_digit);
               double LastCandleL = NormalizeDouble(iLow(NULL,in1mTradePeriod?PERIOD_M1:PERIOD_M5,1+k),Symb_digit);
         
               if((LastCandleH > CurPeriod_Ref_lvl)&&(CurPeriod_Ref_lvl > LastCandleL))
                 {
                     Print("сброс касания и направления из-за касения Реф.уровня - ", CurPeriod_Ref_lvl);
                     IsLvlToched = 0;
                     IsTradeSituationChosen = 0;
                 }
           
           
           
           
         
         
      if(IsLvlToched && !IsTradeSituationChosen)
        {
         // double TrgCandleC3 = iClose(NULL,in1mTradePeriod?PERIOD_M1:PERIOD_M5,3);
         //double TrgCandleC2 = iClose(NULL,in1mTradePeriod?PERIOD_M1:PERIOD_M5,2);
         double TrgCandleC1 = iClose(NULL,in1mTradePeriod?PERIOD_M1:PERIOD_M5,1+k);

         // char TrgCandlePos = (TrgCandleC1 > CurPeriod_Trade_lvl)?1:-1;


         for(uchar i = 2; i <= inTradePeriodCNT ; i++)
           {
            double TrgCandleCn = iClose(NULL,in1mTradePeriod?PERIOD_M1:PERIOD_M5,i+k);
            if(TrgCandleC1 > CurPeriod_Trade_lvl)
              {
               if(TrgCandleCn > CurPeriod_Trade_lvl)
                 {
                  if(((bool)(IsDirTradefl & 0x4) && (IsLvlToched>0)) ||((bool)(IsDirTradefl & 0x2) && (IsLvlToched<0)))
                     IsTradeSituationChosen = IsLvlToched;
                  continue;

                 }
               else
                 {
                  IsTradeSituationChosen = 0;
                  break;
                 }
              }
            else
              {
               if(TrgCandleCn < CurPeriod_Trade_lvl)
                 {
                  if(((bool)(IsDirTradefl & 0x2) && (IsLvlToched>0)) ||((bool)(IsDirTradefl & 0x4) && (IsLvlToched<0)))
                     IsTradeSituationChosen =(char)(- IsLvlToched);
                  continue;

                 }
               else
                 {
                  IsTradeSituationChosen = 0;
                  break;
                 }

              }

           }


         if(IsTradeSituationChosen)
           {


            if((IsLvlToched * IsTradeSituationChosen)>0)
              {
               TradeSignalfl = 1;
               //TradeSignalModfl = 1;
               //IsTradeSituationChosen = 0;
               //InnerBar_signal = 0;
               //IsLvlToched = 0;
              }
            if((IsLvlToched * IsTradeSituationChosen)<0)
              {
               TradeSignalfl = -1;
               //TradeSignalModfl = -1;
               //IsTradeSituationChosen = 0;
               //InnerBar_signal = 0;
               // IsLvlToched = 0;
              }
            if(inBigDayfl)
              {
               if(BigDaySigfl == 0)
                 {
                  TradeSignalfl = 0;
                  TradeSignalModfl = 0;
                  IsTradeSituationChosen = 0;
                 }
              }
            if((bool)(IsDirTradefl & 0x1))
              {
               if((CurPeriod_Trade_lvl > CurPeriod_Aver_lvl) && (TradeSignalfl < 0))
                 {
                  IsTradeSituationChosen = 0;
                  TradeSignalfl = 0;
                  TradeSignalModfl = 0;
                 }
               if((CurPeriod_Trade_lvl < CurPeriod_Aver_lvl) && (TradeSignalfl > 0))
                 {
                  IsTradeSituationChosen = 0;
                  TradeSignalfl = 0;
                  TradeSignalModfl = 0;
                 }
              }

           }
         //(iClose(NULL,in1mTradePeriod?PERIOD_M1:PERIOD_M5,1)

        } // if(IsLvlToched && !IsTradeSituationChosen)
         if(IsLvlToched && IsTradeSituationChosen){
                  if(LastCandleH > CurPeriod_Cancel_lvl_H){
                           
                           Print("Одер отменен из-за пробития уровня отмены H");
                           Print("LastCandleH = ",LastCandleH);
                           Print("текущий CurPeriod_Cancel_lvl_H: ", CurPeriod_Cancel_lvl_H);

                           CancelAllPendingOrderBySymb(_Symbol, Magic_num);
                           IsLvlToched = 0;
                           IsTradeSituationChosen = 0;
                     
                     } 
                     
                   if(LastCandleL < CurPeriod_Cancel_lvl_L){
                       
                        Print("Одер отменен из-за пробития уровня отмены L");
                        Print("LastCandleL = ",LastCandleL);
                        Print("текущий CurPeriod_Cancel_lvl_L: ", CurPeriod_Cancel_lvl_L);
                        
                        CancelAllPendingOrderBySymb(_Symbol, Magic_num);
                        IsLvlToched = 0;
                        IsTradeSituationChosen = 0;
                     
                    }
                  
          
           
           }
           
           
           
           
           
         k--;
        } // while(k>0){
       }// if( InnerBar_signal){
       else{
            Print("Внутренний бар НЕ найден, CurPeriod_Aver_lvl = ", CurPeriod_Aver_lvl);
       }

   Print("InnerBar_signal =", InnerBar_signal,",  IsLvlToched = ",IsLvlToched,", IsTradeSituationChosen = ",IsTradeSituationChosen);
//Print(" расстояние в минуте ", minute_value);
// BUplusfl = inBUplusfl;
// TrlSLfl = inTrlSLfl;
// Trade_a_Period_Quantity = inQu_of_Trade_a_Period;
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
  
  
                         Print("текущий Символ: ", _Symbol);
                       Print("текущий АТR_D: ", ATR_D);
                       Print("текущий SL: ", CurSL);
                       Print("текущий TP: ", CurTP);
                       Print("текущий CurBUplus: ", CurBUplus);
                       Print("текущий CurBUminus: ", CurBUminus);
                       Print("текущий CurTPBUval: ", CurTPBUval);
                       Print("текущий CurTPBUprof: ", CurTPBUprof);
                       Print("текущий CurCansLVL: ", CurCansLVL);
                       
          Print("текущий АТR_5: ",ATR_5);
          Print("текущий ATR_10: ",ATR_10);        
          Print("текущий ATR_15: ",ATR_15);
          Print("текущий ATR_30: ",ATR_30);
          Print("текущий ATR_60: ",ATR_60);
          Print("текущий ATR_120: ",ATR_120);
          Print("текущий ATR_240: ",ATR_240);
          Print("текущий ATR_360: ",ATR_360);
          Print("текущий ATR_480: ",ATR_480);
          Print("текущий ATR_720: ",ATR_720);
   if(ObjectsTotal(0,0,-1))
      ObjectsDeleteAll(0,0,-1);
//---

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   if(t_m != iTime(NULL,in1mTradePeriod?PERIOD_M1:PERIOD_M5,0))  //in1mTradePeriod?PERIOD_M1:PERIOD_M5
     {
      t_m = iTime(NULL,in1mTradePeriod?PERIOD_M1:PERIOD_M5,0);
      TimeToStruct(t_m,CurTick_Date);

      if(t_d != iTime(NULL,PERIOD_D1,0))    //+ ((in1mTradePeriod)? (minute_value*3) :(minute_value*15))
        {
         t_d = iTime(NULL,PERIOD_D1,0);
         double CandleSizeSum = 0;
          ATR_D = 0;
         for(int i = 1; i<= inATRcntVal; i++)
           {

            CandleSizeSum += iHigh(NULL,PERIOD_D1,i) - iLow(NULL,PERIOD_D1,i);

           }
         ATR_D = (CandleSizeSum/inATRcntVal) / Symb_Point;
         
         //ATR_D = (int)((CandleSizeSum/inATRcntVal)/ Symb_Point);
         if(inBigDayfl)
           {
            //if(BigDayD2>0)
            //   {BigDayD3 = BigDayD2;}
            //else{
            //   BigDayD3 = iHigh(NULL,PERIOD_D1,3) - iLow(NULL,PERIOD_D1,3);
            //   if(iOpen(NULL,PERIOD_D1,3) > iClose(NULL,PERIOD_D1,3))
            //     { BigDayD3 *= -1;}
            //}
            if(BigDayD1>0)
              {BigDayD2 = BigDayD1;}
            else
              {
               BigDayD2 = iHigh(NULL,PERIOD_D1,2) - iLow(NULL,PERIOD_D1,2);
               if(iOpen(NULL,PERIOD_D1,2) > iClose(NULL,PERIOD_D1,2))
                 {BigDayD2 *= -1;}
              }
            BigDayD1 = iHigh(NULL,PERIOD_D1,1) - iLow(NULL,PERIOD_D1,1);
            if(iOpen(NULL,PERIOD_D1,1) > iClose(NULL,PERIOD_D1,1))
              {BigDayD1 *= -1;}
            //                        double LastCandlH = 0;
            //                        double LastCandlL = 0;
            //                        double PrevLstCandlH = 0;
            //                        double PrevLstCandlL = 0;
            //
            //                         LastCandlH = iHigh(NULL,PERIOD_D1,1);
            //                         LastCandlL = iLow(NULL,PERIOD_D1,1);
            //                         PrevLstCandlH = iHigh(NULL,PERIOD_D1,2);
            //                         PrevLstCandlL = iLow(NULL,PERIOD_D1,2);


            //                        if(
            //                             (NormalizeDouble(LastCandlH,Symb_digit) < NormalizeDouble(PrevLstCandlH,Symb_digit)) &&
            //                             (NormalizeDouble(LastCandlL,Symb_digit) > NormalizeDouble(PrevLstCandlL,Symb_digit)) &&
            //                                  (inBigBarFDfl?
            //                                    ((LastCandlH - LastCandlL)*inBBFDKoefMul < (PrevLstCandlH - PrevLstCandlL))
            //                                     :true
            //                                  )
            //
            //                           )



            //  if((ATR_D*inBigDayKoef) > (BigDayD1))
                BigDayTrend2 = BigDayTrend1;
                
             if((MathAbs(BigDayD1 * inBigDayKoef) < MathAbs(BigDayD2)) //&&
                  //(MathAbs(BigDayD2 * inBigDayKoef) < MathAbs(BigDayD3)) &&
                  //(inBigDayDirfl?(((BigDayD1 * BigDayD2) > 0)/*&&((BigDayD1 * BigDayD3) > 0)*/):true)
                  )
                 {
                  BigDaySigfl = (BigDayD1>0)?1:-1;
                  BigDayTrend1 = -1;
                  }
   
               else{
                  BigDaySigfl = 0;
                  BigDayTrend1 = 1;
               }
           }

         if(inATRedSLTP)
           {
            Print("текущий Символ: ", _Symbol);
            int ATRi = (int)(ATR_D);
            Print("текущий АТR: ",ATRi);
            CurSL = (int)(ATRi * inATR_SLk);
            CurSL = (int)((CurSL*inATRusageVal + inSL)/ (1+inATRusageVal));
            if(inSLmin && (CurSL < inSLmin)) CurSL = inSLmin;
            if(inSLmax && (CurSL > inSLmax)) CurSL = inSLmax;
            Print("текущий SL: ", CurSL);
            
            CurTP = (int)(ATRi * inATR_TPk);
            CurTP = (int)((CurTP*inATRusageVal + inTP)/(1+inATRusageVal));
            if(inTPmax && (CurTP > inTPmax)) CurTP = inTPmax;
            Print("текущий TP: ", CurTP);
            
            CurBUplus = (int)(CurSL * inATR_BUpk);
            Print("текущий CurBUplus: ", CurBUplus);
            
            CurBUminus =(int)(CurSL * inATR_BUmk);
            Print("текущий CurBUminus: ", CurBUminus);
            CurTPBUval = (int)((CurSL - CurBUminus) * inATR_BUtpk);
            Print("текущий CurTPBUval: ", CurTPBUval);
            CurTPBUprof = (int)(CurTP * inATR_BUtpProfk);
            Print("текущий CurTPBUprof: ", CurTPBUprof);
            Print("текущий CurCansLVL: ", CurCansLVL);
            CurCansLVL = (int)(CurSL * inATR_CansLk);
            CurRevCansLVL = (int)(CurSL * inATR_RCansLk);
            if(Symb_Point == 1)
              {
               CurTP /= 10;
               CurSL /= 10;
               CurBUplus /= 10;
               CurBUminus /= 10;
               CurTPBUval  /= 10;
               CurTPBUprof  /= 10;
               //CurCansLVL  /= 10;
              // CurRevCansLVL  /= 10;

               CurTP *= 10;
               CurSL *= 10;
               CurBUplus *= 10;
               CurBUminus *= 10;
               CurTPBUval  *= 10;
               CurTPBUprof  *= 10;
               //CurCansLVL *= 10;
              // CurRevCansLVL  *= 10;
              }

           } //if(inATRedSLTP)


        } //(t_d != iTime(NULL,PERIOD_D1,0))

      if(t_p != iTime(NULL,PERIOD_CURRENT,0))  //+ ((in1mTradePeriod)? (minute_value*3) :(minute_value*15))
        {
         t_p = iTime(NULL,PERIOD_CURRENT,0) ; //+ ((in1mTradePeriod)? (minute_value*3) :(minute_value*15))
         //if(ObjectsTotal(0,0,-1)) ObjectsDeleteAll(0,0,-1);
         //CloseAllPositionsBySymb(_Symbol);
         TimeToStruct(t_p, CurPeriod_Date);

         double LastCandlH = 0;
         double LastCandlL = 0;
         double PrevLstCandlH = 0;
         double PrevLstCandlL = 0;

         if(inFloatSize)
           {
            LastCandlH = iHigh(NULL,PERIOD_CURRENT,iHighest(NULL,PERIOD_CURRENT,MODE_HIGH,CurBoxSize,1));
            LastCandlL = iLow(NULL,PERIOD_CURRENT,iLowest(NULL,PERIOD_CURRENT,MODE_LOW,CurBoxSize,1));
            PrevLstCandlH = iHigh(NULL,PERIOD_CURRENT,iHighest(NULL,PERIOD_CURRENT,MODE_HIGH,CurBoxSize,1+CurBoxSize));
            PrevLstCandlL = iLow(NULL,PERIOD_CURRENT,iLowest(NULL,PERIOD_CURRENT,MODE_LOW,CurBoxSize,1+CurBoxSize));
           }
         else
           {
            LastCandlH = iHigh(NULL,PERIOD_CURRENT,1);
            LastCandlL = iLow(NULL,PERIOD_CURRENT,1);
            PrevLstCandlH = iHigh(NULL,PERIOD_CURRENT,2);
            PrevLstCandlL = iLow(NULL,PERIOD_CURRENT,2);
           }




         if(
            (NormalizeDouble(LastCandlH,Symb_digit) < NormalizeDouble(PrevLstCandlH,Symb_digit)) &&
            (NormalizeDouble(LastCandlL,Symb_digit) > NormalizeDouble(PrevLstCandlL,Symb_digit)) &&
            (inVolfl?
             //((inVolfl)?(iVolume(NULL,PERIOD_CURRENT,1) > iVolume(NULL,PERIOD_CURRENT,2)):true) ||
             (iVolume(NULL,PERIOD_CURRENT,1) > iVolume(NULL,PERIOD_CURRENT,2))
             :true
            ) &&
            (inBigBarfl?
             ((LastCandlH - LastCandlL)*inBBKoefMul < (PrevLstCandlH - PrevLstCandlL))
             :true
            ) &&
            (inMinBoxSize?
            (((LastCandlH - LastCandlL)/Symb_Point) > inMinBoxSize)
            :true)

         )
           {
            if(!isPositionOpenfl)
              {
               //IsLvlToched = 0;   ??????????????????????
               Reverse_a_Period_Quantity = inQu_of_Reverse_a_Trade;
               CurPeriod_Trade_lvl = 0;
               CurPeriod_Ref_lvl = 0;
               CurPeriod_Stop_lvl = 0;
               LastSL = 0;
               
              }
              CurPeriod_High_lvl_prev = PrevLstCandlH;
               CurPeriod_Low_lvl_prev = PrevLstCandlL;
            IsLvlToched = 0;
            IsTradeSituationChosen = 0;
            CurPeriod_High_lvl = 0;
            CurPeriod_Low_lvl = 0;
            IsDirTradefl = inDirTrade;
            //IsProboyfl = inProboyfl;
            //IsOtskokfl = inOtskokfl;
            //IsOutOfBarfl = inOutOfBarfl;
            Trade_a_Period_Quantity = inQu_of_Trade_a_Period;



            CurPeriod_High_lvl = NormalizeDouble(LastCandlH,Symb_digit);


            CurPeriod_Low_lvl = NormalizeDouble(LastCandlL,Symb_digit);

            CurPeriod_Aver_lvl = NormalizeDouble(((CurPeriod_High_lvl + CurPeriod_Low_lvl)/2),Symb_digit);
            if(inFloatSize)
              {
               ObjectCreate(0,"Last_Rect",OBJ_RECTANGLE,0,
                            iTime(NULL,PERIOD_CURRENT,CurBoxSize),LastCandlH,
                            iTime(NULL,PERIOD_CURRENT,1),LastCandlL);
               ObjectCreate(0,"Prev_Rect",OBJ_RECTANGLE,0,
                            iTime(NULL,PERIOD_CURRENT,CurBoxSize+CurBoxSize),PrevLstCandlH,
                            iTime(NULL,PERIOD_CURRENT,CurBoxSize+1),PrevLstCandlL);
               ObjectCreate(0,"HorH_Line",OBJ_HLINE,0,t_p,CurPeriod_High_lvl);
               ObjectCreate(0,"HorL_Line",OBJ_HLINE,0,t_p,CurPeriod_Low_lvl);

              }
            else
              {
               ObjectCreate(0,"HorH_Line",OBJ_HLINE,0,t_p,CurPeriod_High_lvl);
               ObjectCreate(0,"HorL_Line",OBJ_HLINE,0,t_p,CurPeriod_Low_lvl);
               ObjectCreate(0,"Vert_line",OBJ_VLINE,0,iTime(NULL,PERIOD_CURRENT,2),LastCandlH);
              }
            //AddLVLs_toStr(CurPeriod_High_lvl,CurPeriod_Low_lvl,t_p);
            //AddLVLaver_toStr(CurPeriod_Aver_lvl,LVL_width,t_p);

            InnerBar_signal = 1;
            if(inFloatSizeCh)
               CurBoxSize++;
            InnerBar_signal_TimeSt = t_p;
            if(isOrderPlacedfl){
               if(CancelAllPendingOrderBySymb(_Symbol, Magic_num))
                 {
                  isOrderPlacedfl = false;
                  Print("Одер отменен из-за формирования нового сигнала внутр.бара(коробочки)");
                 }
               else
                 {
                  t_m = 0;
                   Print("ошибка отменения ордера из-за формирования нового сигнала внутр.бара(коробочки)");
                  return;
                 }
              }
           } //if внутреннтй бар

         if(InnerBar_signal &&((t_p - InnerBar_signal_TimeSt) >= PeriodSeconds(PERIOD_CURRENT)*InnerBar_Exp_cnt))
           {
            InnerBar_signal=0;
            TradeSignalfl = 0;
            IsLvlToched = 0;
            //TradeSignalModfl = 0;
            // IsTradeSituationChosen=0;
            if(isOrderPlacedfl){
               if(CancelAllPendingOrderBySymb(_Symbol, Magic_num))
                 {
                  isOrderPlacedfl = false;
                  Print("Одер отменен из-за из-за истечения InnerBar_Exp_cnt");
                 }
               else
                 {
                  t_m = 0;
                  return;
                 }
              }

           }
         if(isRevPosAllowfl &&((t_p - InnerBar_signal_TimeSt) >= PeriodSeconds(PERIOD_CURRENT)*ReverseBar_Exp_cnt))
           {
            isRevPosAllowfl  = 0;
           }
        }//(t_p != iTime(NULL,PERIOD_CURRENT,0) )

      double LastCandleH = iHigh(NULL,in1mTradePeriod?PERIOD_M1:PERIOD_M5,1);
      double LastCandleL = iLow(NULL,in1mTradePeriod?PERIOD_M1:PERIOD_M5,1);

      if(InnerBar_signal && !IsLvlToched)
        {
         // if((t_m - InnerBar_signal_TimeSt) > (PeriodSeconds(in1mTradePeriod?PERIOD_M1:PERIOD_M5)*(inTradePeriodCNT+1))) //(inDopTradePeriod?4:3)
         // {
         double TrgCandleH = iHigh(NULL,in1mTradePeriod?PERIOD_M1:PERIOD_M5,2);
         double TrgCandleL = iLow(NULL,in1mTradePeriod?PERIOD_M1:PERIOD_M5,2);
         double TrgCandleO = iOpen(NULL,in1mTradePeriod?PERIOD_M1:PERIOD_M5,2);

         if((TrgCandleH >= CurPeriod_High_lvl)&&(CurPeriod_High_lvl >= TrgCandleL))
           {
            CurPeriod_Trade_lvl = CurPeriod_High_lvl;
            Print("текущий CurPeriod_Trade_lvl(H): ", CurPeriod_Trade_lvl);
            CurPeriod_Ref_lvl = CurPeriod_Low_lvl;
            
            
            CurPeriod_Cancel_lvl_H = CurPeriod_High_lvl + (CurCansLVL*Symb_Point);
           // Print("текущий CurPeriod_Cancel_lvl_H: ", CurPeriod_Cancel_lvl_H);
            
            CurPeriod_Cancel_lvl_L = CurPeriod_High_lvl - (CurCansLVL*Symb_Point);
           // Print("текущий CurPeriod_Cancel_lvl_L: ", CurPeriod_Cancel_lvl_L);
            
            CurPeriod_CancelRev_lvl_H = CurPeriod_Trade_lvl + (CurRevCansLVL *Symb_Point);
            CurPeriod_CancelRev_lvl_L = CurPeriod_Trade_lvl - (CurRevCansLVL *Symb_Point);


            if(TrgCandleO < CurPeriod_Trade_lvl)
               IsLvlToched = 1;
            else
              {
               if(TrgCandleO > CurPeriod_Trade_lvl)
                  IsLvlToched = -1;
               else
                  IsLvlToched = 0;
              }
           }
         // else{
         if((TrgCandleH >= CurPeriod_Low_lvl)&&(CurPeriod_Low_lvl >= TrgCandleL))
           {
            if(IsLvlToched)
              {
               IsLvlToched = 0;
              }
            else
              {
               // if(!((TrgCandleH < CurPeriod_High_lvl)&&(CurPeriod_High_lvl > TrgCandleL)))
               CurPeriod_Trade_lvl = CurPeriod_Low_lvl;
               Print("текущий CurPeriod_Trade_lvl(L): ", CurPeriod_Trade_lvl);
               CurPeriod_Ref_lvl = CurPeriod_High_lvl;
               //CurPeriod_Stop_lvl = CurPeriod_High_lvl_prev;
               
               CurPeriod_Cancel_lvl_H = CurPeriod_Low_lvl + (CurCansLVL*Symb_Point);
              // Print("текущий CurPeriod_Cancel_lvl_H: ", CurPeriod_Cancel_lvl_H);
               
               CurPeriod_Cancel_lvl_L = CurPeriod_Low_lvl - (CurCansLVL*Symb_Point);
             //  Print("текущий CurPeriod_Cancel_lvl_L: ", CurPeriod_Cancel_lvl_L);

               CurPeriod_CancelRev_lvl_H = CurPeriod_Trade_lvl + CurRevCansLVL *Symb_Point;
               CurPeriod_CancelRev_lvl_L = CurPeriod_Trade_lvl - CurRevCansLVL *Symb_Point;
   
               if(TrgCandleO < CurPeriod_Trade_lvl)
                  IsLvlToched = 1;
               else
                 {
                  if(TrgCandleO > CurPeriod_Trade_lvl)
                     IsLvlToched = -1;
                  else
                     IsLvlToched = 0;
                 }
              }

           }
         //  }
         // } //if((t_m - t_p) > (PeriodSeconds(in1mTradePeriod?PERIOD_M1:PERIOD_M5)*3))
         
        } //  if(InnerBar_signal && !IsLvlToched)

      if((LastCandleH > CurPeriod_Ref_lvl)&&(CurPeriod_Ref_lvl > LastCandleL))
        {
         IsLvlToched = 0;
         IsTradeSituationChosen = 0;
        }
      if(IsLvlToched && !IsTradeSituationChosen)
        {
         // double TrgCandleC3 = iClose(NULL,in1mTradePeriod?PERIOD_M1:PERIOD_M5,3);
         //double TrgCandleC2 = iClose(NULL,in1mTradePeriod?PERIOD_M1:PERIOD_M5,2);
         double TrgCandleC1 = iClose(NULL,in1mTradePeriod?PERIOD_M1:PERIOD_M5,1);

         // char TrgCandlePos = (TrgCandleC1 > CurPeriod_Trade_lvl)?1:-1;


         for(uchar i = 2; i <= inTradePeriodCNT ; i++)
           {
            double TrgCandleCn = iClose(NULL,in1mTradePeriod?PERIOD_M1:PERIOD_M5,i);
            if(TrgCandleC1 > CurPeriod_Trade_lvl)
              {
               if(TrgCandleCn > CurPeriod_Trade_lvl)
                 {
                  if(((bool)(IsDirTradefl & 0x4) && (IsLvlToched>0)) ||((bool)(IsDirTradefl & 0x2) && (IsLvlToched<0)))
                     IsTradeSituationChosen = IsLvlToched;
                  continue;

                 }
               else
                 {
                  IsTradeSituationChosen = 0;
                  break;
                 }
              }
            else
              {
               if(TrgCandleCn < CurPeriod_Trade_lvl)
                 {
                  if(((bool)(IsDirTradefl & 0x2) && (IsLvlToched>0)) ||((bool)(IsDirTradefl & 0x4) && (IsLvlToched<0)))
                     IsTradeSituationChosen =(char)(- IsLvlToched);
                  continue;

                 }
               else
                 {
                  IsTradeSituationChosen = 0;
                  break;
                 }

              }

           }


         if(IsTradeSituationChosen)
           {
           
            

            if((IsLvlToched * IsTradeSituationChosen)>0)
              {
               TradeSignalfl = 1;
               TradeSignalModfl = 1;
               //if(inSLbyChanal)
                  CurPeriod_Stop_lvl = CurPeriod_Low_lvl_prev;
                  
                  
               //IsTradeSituationChosen = 0;
               //InnerBar_signal = 0;
               //IsLvlToched = 0;
              }
            if((IsLvlToched * IsTradeSituationChosen)<0)
              {
               TradeSignalfl = -1;
               TradeSignalModfl = -1;
               //if(inSLbyChanal)
                  CurPeriod_Stop_lvl = CurPeriod_High_lvl_prev;
               //IsTradeSituationChosen = 0;
               //InnerBar_signal = 0;
               // IsLvlToched = 0;
              }
              
 
            if(inBigDayTradefl)
              {
               if(BigDaySigfl == 0)
                 {
                  TradeSignalfl = 0;
                  TradeSignalModfl = 0;
                  IsTradeSituationChosen = 0;
                 }
              }
            if((bool)(IsDirTradefl & 0x1))
              {
               if((CurPeriod_Trade_lvl > CurPeriod_Aver_lvl) && (TradeSignalfl < 0))
                 {
                  IsTradeSituationChosen = 0;
                  TradeSignalfl = 0;
                  TradeSignalModfl = 0;
                 }
               if((CurPeriod_Trade_lvl < CurPeriod_Aver_lvl) && (TradeSignalfl > 0))
                 {
                  IsTradeSituationChosen = 0;
                  TradeSignalfl = 0;
                  TradeSignalModfl = 0;
                 }
              }
              if(inSLbyChanal && (bool)(TradeSignalfl)){
            
                  CurSL = (int)((TradeSignalfl*(CurPeriod_Trade_lvl - CurPeriod_Stop_lvl))/Symb_Point+inSLadd);
            
                  if(inSLmin && (CurSL < inSLmin)) CurSL = inSLmin;
                  if(inSLmax && (CurSL > inSLmax)) CurSL = inSLmax;
                  Print("текущий SL: ", CurSL);
                  
                  CurTP = (int)(CurSL * inATR_TPk);
                  CurTP = (int)((CurTP*inATRusageVal + inTP)/(1+inATRusageVal));
                  if(inTPmax && (CurTP > inTPmax)) CurTP = inTPmax;
                  Print("текущий TP: ", CurTP);
                  
                  CurBUplus = (int)(CurSL * inATR_BUpk);
                  Print("текущий CurBUplus: ", CurBUplus);
                  
                  CurBUminus =(int)(CurSL * inATR_BUmk);
                  Print("текущий CurBUminus: ", CurBUminus);
                  CurTPBUval = (int)((CurSL - CurBUminus) * inATR_BUtpk);
                  Print("текущий CurTPBUval: ", CurTPBUval);
                  CurTPBUprof = (int)(CurTP * inATR_BUtpProfk);
                  Print("текущий CurTPBUprof: ", CurTPBUprof);
            }
            
            if(inSLTPlim){
               if(((int)(CurTP/CurSL))<inSLTPlim){
                   TradeSignalfl = 0;
                   TradeSignalModfl = 0;
                   IsTradeSituationChosen = 0;
               }
            
            } 
            if(inFloatSizeCh){
               if(inFloatSizeChLim &&(CurBoxSize < inFloatSizeChLim)){
                  TradeSignalfl = 0;
                  TradeSignalModfl = 0;
                  IsTradeSituationChosen = 0;
               }
               CurBoxSize = inBoxSize;
            }
           }
         //(iClose(NULL,in1mTradePeriod?PERIOD_M1:PERIOD_M5,1)

        } // if(IsLvlToched && !IsTradeSituationChosen)

      //if(CountPositions(Magic_num,_Symbol) > 0)
      if(CountPositions(_Symbol) > 0)
        {
         //Служебная переменная для контроля закрытия позиции
         //bool isClosed = false;

         //Переменные под значения свойств позиции
         ulong positon = 0;


         char pos_typechr = 0;
         datetime pos_op_time = 0;
         double pos_op_price = 0;
         double pos_sl = 0, pos_tp = 0;



         //Кеширование данных позиции и присвоение
         //соответствующих переменных
         if(PositionSelect(_Symbol))
           {
            //Print(PositionGetString(POSITION_COMMENT));
            positon = PositionGetInteger(POSITION_TICKET);
            pos_sl = PositionGetDouble(POSITION_SL);
            pos_tp = PositionGetDouble(POSITION_TP);
            //if(StringCompare(PositionGetString(POSITION_COMMENT),"[variation margin open]") == 0)
            //  {
            //   if(inPrintfl == 1){
            //      Print("[variation margin open]");
            //   }
               if(HistorySelectByPosition(PositionGetInteger(POSITION_IDENTIFIER)))
                 {
                                                   //if(inPrintfl == 1){
                                                   //     Print("POSITION_IDENTIFIER found");
                                                   //}
                  uint     total=HistoryDealsTotal();
                  if(total > 1){
                                    if(inPrintfl == 1){
                                      Print("Position total > 1, = ",total);
                                    }
                     datetime ticket_erlst_datetime = TimeCurrent()+1; 
                                    if(inPrintfl == 1){
                                      Print("Time current= ",ticket_erlst_datetime);
                                    }
                        ulong ticket_erlst = 0;
                        
                     for(uint i=0; i<total; i++){
                           ulong ticket = HistoryDealGetTicket(i);
                           
                           //--- получим тикет сделки по его позиции в списке
                           //long mgk = 0;
                           
                           if(ticket>0){
                                 datetime CurTicetOpTime = (datetime)HistoryDealGetInteger(ticket,DEAL_TIME);
                                                if(inPrintfl == 1){
                                                   Print("Cur position op_time = ",CurTicetOpTime);
                                                }
                                 if(CurTicetOpTime < ticket_erlst_datetime){
                                       ticket_erlst_datetime = CurTicetOpTime;
                                                         if(inPrintfl == 1){
                                                           Print("Erlst position op_time = ",ticket_erlst_datetime);
                                                         }
                                       ticket_erlst = ticket;
                                                         if(inPrintfl == 1){
                                                           Print("Erlst position ticet = ",ticket_erlst);
                                                         }
                                 }
                            }
                        }

                           //if(HistoryDealGetInteger(ticket,DEAL_MAGIC,mgk)){
                          long Deal_typ ;
                          
                           if(HistoryDealGetInteger(ticket_erlst,DEAL_ENTRY,Deal_typ))
                           
                             {
                             if(Deal_typ == DEAL_ENTRY_IN){
                                 if(inPrintfl == 1){
                                     Print("DEAL_ENTRY_IN found ", Deal_typ);
                                 }
                              ENUM_DEAL_TYPE pos_type = 0;
                              pos_type = (ENUM_DEAL_TYPE)HistoryDealGetInteger(ticket_erlst,DEAL_TYPE);
                              if(pos_type == DEAL_TYPE_BUY)
                                { pos_typechr = 1;}
                              else
                                 if(pos_type == DEAL_TYPE_SELL)
                                   { pos_typechr = -1;}
                              pos_op_time = (datetime)HistoryDealGetInteger(ticket_erlst,DEAL_TIME);
                                                if(inPrintfl == 1){
                                                  Print("pos_op_time = ",pos_op_time);
                                                }
                              pos_op_price = HistoryDealGetDouble(ticket_erlst,DEAL_PRICE);
                                                if(inPrintfl == 1){
                                                    Print("pos_op_price: ", pos_op_price);
                                                }
                              
                              
                             }
                             }
                         else{
                                  if(inPrintfl == 2){
                                       Print("POSITION_IDENTIFIER NOT! found");
                                  }
                             }
                           //}
                         // }
                       
                   }
                   else{
                                    //if(inPrintfl == 1){
                                    //  Print("Position total == 1");
                                    //}
                        ENUM_POSITION_TYPE pos_type = 0;
                        pos_type = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
                        if(pos_type == POSITION_TYPE_BUY)
                          { pos_typechr = 1;}
                        else if(pos_type == POSITION_TYPE_SELL)
                          { pos_typechr = -1;}
                        pos_op_time = (datetime)PositionGetInteger(POSITION_TIME);
                        pos_op_price = PositionGetDouble(POSITION_PRICE_OPEN);
                        
                        
                   
                   }

                 }


               if(!isPositionOpenfl)
                 {
                  CurPositionID = positon;
                  isPositionOpenfl = pos_typechr;
                  LastSL = PositionGetDouble(POSITION_SL);
                  isOrderPlacedfl = false;
                 }
              
            //pos_tp = PositionGetDouble(POSITION_TP);
           }
         // if(pos_op_time < t_m){
         //                  if(pos_type == POSITION_TYPE_BUY){
         //
         //                  }
         //Смотрим незакрытую прибыль позиции


         int profit = 0; //ProfitPipMax(positon);
         int drawdoun = 0;

         if(pos_typechr > 0)
           {
            profit = (int)((LastCandleH - pos_op_price)/Symb_Point);
            drawdoun = (int)((pos_op_price - LastCandleL)/Symb_Point);
           }
         else
            if(pos_typechr < 0)
              {
               profit = (int)((pos_op_price - LastCandleL)/Symb_Point);
               drawdoun = (int)((LastCandleH - pos_op_price)/Symb_Point);
              }


         //(int)((iHigh(pos_symb,PERIOD_M1,1) - pos_op_price)/symb_point);
         //Если прибыль удовлетворяет условиям торгового
         //алгоритма - переносим БУ(если активно)
         if(BUplusfl && CurBUplus && (profit > CurBUplus))
           {
              Print("BU_Plus, Position_SLBU_add_Modofy");
              Print("pos_op_price: ",pos_op_price,"   newSL: ",pos_op_price + (pos_typechr * inBUadd * Symb_Point));
           if(!Position_SLTP_Modofy(positon,pos_op_price + (pos_typechr * inBUadd * Symb_Point),pos_tp))
            //if(!Position_SLBU_add_Modofy(positon,inBUadd))
               //if(!Position_SLTP_Modofy(positon,CurBUplus,0))
              {
               //Перезапуск глав. функции на случай ошибки закрытия позиции
               t_m = 0;
               return;
              }

            //Trade_a_Period_Quantity++;
            Reverse_a_Period_Quantity++;
            BUtrigedfl = 1;
            BUplusfl = false;
           }

         if(BUminusfl && CurBUminus && (drawdoun > CurBUminus))   //(CurSL*inBUminusoKoef)
           {
              Print("BU_minus, Position_SLTP_Modofy, TP:", pos_tp," -> ",pos_op_price + (pos_typechr * inBUadd * Symb_Point));
              Print("pos_op_price: ",pos_op_price);
            if(!Position_SLTP_Modofy(positon,pos_sl,pos_op_price + (pos_typechr * inBUadd * Symb_Point)))
              {
               //Перезапуск глав. функции на случай ошибки закрытия позиции
               t_m = 0;
               return;
              }

            Reverse_a_Period_Quantity++;
            BUtrigedfl = -1;
            BUminusfl = false;
            MoveTPBUfl = false;
           }
         if(MoveTPBUfl && (CurTPBUval) && (drawdoun > (CurTPBUval)))
           {
              Print("BU_TP, Position_TPBU_add_Modofy, TP: 0+ ",CurTPBUprof?CurTPBUprof:inBUadd);
              Print("pos_op_price: ",pos_op_price);            
           // if(!Position_TPBU_add_Modofy(positon,CurTPBUprof?CurTPBUprof:inBUadd))
            if(!Position_SLTP_Modofy(positon,pos_sl,CurTPBUprof?(pos_op_price + (pos_typechr * CurTPBUprof * Symb_Point)):(pos_op_price + (pos_typechr * inBUadd * Symb_Point))))
              {
               //Перезапуск глав. функции на случай ошибки закрытия позиции
               t_m = 0;
               return;
              }

              MoveTPBUfl = false;
           }


         if(TrlSLfl && inTrlSLstepLvl && (profit > (BUplusfl?CurBUplus:0) + TrlSLlvl))
           {
              Print("TrlStp, Position_TRlSL_Modofy, TrlSLlvl:",(BUplusfl?CurBUplus:0)+TrlSLlvl," + ",inTrlSLstep);
              Print("pos_op_price: ",pos_op_price);
           
            if(!Position_TRlSL_Modofy(positon,inTrlSLstep))
               //if(!Position_SLTP_Modofy(positon,CurBUplus,0))
              {
               //Перезапуск глав. функции на случай ошибки закрытия позиции
               t_m = 0;
               return;
              }
            //isRevPosAllowfl = 0;
            TrlSLlvl += inTrlSLstep;
           }



         if( (bool)(inMoveSLTPfl & 0xF) && (BigDayTrend1 > 0)  && TradeSignalModfl)
           {


            if((TradeSignalModfl*pos_typechr)<0)    //сигнал противоречит направлению позиции - двигаем тейк
              {

               TradeSignalModfl = 0;
               // if(inMoveSLTPfl & 0x1){
               Print("сигнал противоречит направлению позиции, Position_SLTP_Modofy,");
               if(!Position_SLTP_Modofy(positon,((bool)(inMoveSLTPfl&0x1))?((pos_sl+CurPeriod_Trade_lvl)/2):pos_sl,
                                        ((bool)(inMoveSLTPfl&0x4))?(CurPeriod_Trade_lvl):pos_tp))
                 {
                  //Перезапуск глав. функции на случай ошибки закрытия позиции
                  t_m = 0;
                  return;
                 }
               //}

              }
            if((TradeSignalModfl*pos_typechr) > 0)  //сигнал подтверждает направление позиции - (двигаем стоп)
              {

               TradeSignalModfl = 0;

               Print("сигнал подтверждает направление позиции, Position_SLTP_Modofy");
               if(!Position_SLTP_Modofy(positon,((bool)(inMoveSLTPfl&0x2))?((pos_sl+CurPeriod_Trade_lvl)/2):pos_sl,
                                        ((bool)(inMoveSLTPfl&0x8))?(pos_tp + pos_typechr*((pos_sl+CurPeriod_Trade_lvl)/2)):pos_tp))
                 {
                  //Перезапуск глав. функции на случай ошибки закрытия позиции
                  t_m = 0;
                  return;
                 }

              }

           }
      if(PosTimeLim){
         
         if((iBarShift(_Symbol,PERIOD_CURRENT,pos_op_time) > PosTimeLim) && (profit < CurSL * inLimKoef)){ 
              if(profit < 0){
                  Print("PosTimeLim, Position_TRlSL_Modofy, BU = ",pos_op_price + (pos_typechr * inBUadd * Symb_Point));
                   if(!Position_SLTP_Modofy(positon,pos_sl,pos_op_price + (pos_typechr * inBUadd * Symb_Point)))
                       {
                        //Перезапуск глав. функции на случай ошибки закрытия позиции
                        t_m = 0;
                        return;
                       }              
              }
              else{
                  CloseAllPositionsBySymb(_Symbol);
              }
                  
              PosTimeLim =0;
         }
         
      }
//      if(inADXusage){
//        // int calculated = BarsCalculated(ADXhandle);
//          double IndBuf1 [];
//               int size = 3+1;
//          ArrayResize(IndBuf1,size);
//         
//         
//         CopyBuffer(ADXhandle,0,0,4,IndBuf1);//,MAIN_LINE,0,size,StohArray);
//         
//         ArraySetAsSeries(IndBuf1,true);
//         
//         
//      }      

      if(inCloseForNightfl && (CurTick_Date.hour>=23) && (profit < (CurSL*inCloseForNightKoef)))
         CloseAllPositionsBySymb(_Symbol);
      if(inCloseForWeekendfl && (CurTick_Date.day_of_week == 5)&&(CurTick_Date.hour>=21))
         CloseAllPositionsBySymb(_Symbol);
      switch(inClzForContrChange)
        {
         case -1 :{
            if(t_m > (SymbolInfoInteger(_Symbol,SYMBOL_EXPIRATION_TIME) - (PeriodSeconds(PERIOD_H1)*24))){
            
               CloseAllPositionsBySymb(_Symbol);
               Print("CloseAllPositionsBySymb -> ClzForContrChange_-1");
            }
            break;
           }
         case 0 :
           {break;}
         case 1 :{
                   if((CurTick_Date.day >= 27)&&(CurTick_Date.day <= 28)){
                           
                             CloseAllPositionsBySymb(_Symbol);
                             Print("CloseAllPositionsBySymb -> ClzForContrChange_1");
                         } 
                   break;
                   }
         case 2 :
           {
            if(CurTick_Date.mon == 2)
              {
               if(CurTick_Date.day >= 28){
                  CloseAllPositionsBySymb(_Symbol);
                  Print("CloseAllPositionsBySymb -> ClzForContrChange_2.1");
               }
              }
            else
              {
               if(CurTick_Date.day >= 30){
                  CloseAllPositionsBySymb(_Symbol);
                  Print("CloseAllPositionsBySymb -> ClzForContrChange_2.2");
               }
              }
            break;
           }
         case 3 :
           {
            if((CurTick_Date.mon == 3)||(CurTick_Date.mon == 6)||(CurTick_Date.mon == 9)||(CurTick_Date.mon == 12))
              {
               if((CurTick_Date.day >= 16)&&(CurTick_Date.day <= 17))
                 {
                  CloseAllPositionsBySymb(_Symbol);
                  Print("CloseAllPositionsBySymb -> ClzForContrChange_3");
                 }
              }
            break;
           }
         case 4 :
           {
            if(t_m > (SymbolInfoInteger(_Symbol,SYMBOL_EXPIRATION_TIME) - (PeriodSeconds(PERIOD_H1)*24))){
            
               CloseAllPositionsBySymb(_Symbol);
               Print("CloseAllPositionsBySymb -> ClzForContrChange_4");
            }
            break;
           }
         default :
            break;

        } //switch(inCloseForContrChngfl){

        } // (CountPositions(Magic_num,_Symbol) > 0)
      else
         if(AllowedTime(_Symbol,inStartTradingTimeU, inStopTradingTimeU, t_m, inCloseForNightfl, inCloseForWeekendfl, inClzForContrChange, inClzForWar) &&
            isDayAllowed(t_p))
            //(inCloseForNightfl?(CurTick_Date.hour<23):true) &&
            // (inCloseForWeekendfl?((CurTick_Date.day_of_week != 5)&&(CurTick_Date.hour<18)):true))
           {


            if(isOrderPlacedfl)
              {
               HistorySelect(t_m - PeriodSeconds(in1mTradePeriod?PERIOD_M1:PERIOD_M5)*1,TimeCurrent());
               if(HistoryDealsTotal())
                 {
                  // int c = HistoryOrdersTotal();
                  // for
  

                  if(HistoryDealGetInteger(HistoryDealGetTicket(0),DEAL_POSITION_ID, CurPositionID))
                    {
                     // if(CurPositionID > 1){
                     isPositionOpenfl = 1;

                    }

                 }

              }
            if((iHigh(NULL,in1mTradePeriod?PERIOD_M1:PERIOD_M5,1) > CurPeriod_CancelRev_lvl_H)    ||
               (iLow(NULL,in1mTradePeriod?PERIOD_M1:PERIOD_M5,1) < CurPeriod_CancelRev_lvl_L))
              {

               isRevPosAllowfl = 0;
              }


            if(isPositionOpenfl)  // должно быть ТОЛЬКО одно условие!!!!
              {

               if(isRevPosAllowfl  && (Reverse_a_Period_Quantity > 0))  // && (TrlSLlvl == inTrlSLstepLvl) && TradeSignalfl
                 {


                  double ClsdPosOpenPrice = 0;
                  double ClsdPosClosePrice = 0;
                  double ClsdPosFrstSL = 0;
                  int ClsdPosType = 0;



                  if(GetClosedPositionProperty(CurPositionID, ClsdPosType, ClsdPosOpenPrice, ClsdPosClosePrice, ClsdPosFrstSL))
                    {
                     Reverse_a_Period_Quantity--;
                     //if(inReversePositionfl) {
                     //double price_delta = CurPeriod_Trade_lvl  - LastSL;
                     if(ClsdPosType == 1) //  была сделка в бай, нужен переворот в сел
                       {
                        //isRevPosAllowfl = false;
                        if((bool)(inReversePositionfl & 0x1)  &&  /* переворот только если начальный СЛ  inReverseIfSL*/
                           !BUtrigedfl)
                           //(NormalizeDouble(ClsdPosFrstSL,Symb_digit) == NormalizeDouble(ClsdPosClosePrice,Symb_digit)))
                          {
                           if(NormalizeDouble(ClsdPosOpenPrice,Symb_digit) == NormalizeDouble(CurPeriod_Trade_lvl,Symb_digit))
                              TradeSignalfl = -1;
                           //Trade_a_Period_Quantity ++ ;
                           //isRevPosAllowfl = true;
                           // isRevPosAllowfl = 125;/// вот такой флаг !!! =))
                          }
                        if((bool)(inReversePositionfl & 0x2) && (BUtrigedfl > 0))
                          {
                           IsTradeSituationChosen = 0;
                           IsLvlToched = -1;
                           IsDirTradefl = 0x4;
                           //IsProboyfl = true;
                           //IsOtskokfl = false;
                           //IsOutOfBarfl = false;

                          }
                        if((bool)(inReversePositionfl & 0x4) && (BUtrigedfl < 0))
                          {
                           IsTradeSituationChosen = 0;
                           IsLvlToched = 1;
                           IsDirTradefl = 0x2;
                           //IsOtskokfl = true;
                           //IsProboyfl = false;
                           //IsOutOfBarfl = false;

                          }
                        // (IsLvlToched && !IsTradeSituationChosen)
                        //if(BUtrigedfl)
                        //IsOtskokfl = true;


                       }
                     else
                        if(ClsdPosType == -1) //  была сделка в сел, нужен переворот в бай
                          {
                           if((bool)(inReversePositionfl & 0x1)  && !BUtrigedfl) /* переворот только если начальный СЛ*/
                             {
                              if(NormalizeDouble(ClsdPosOpenPrice,Symb_digit) == NormalizeDouble(CurPeriod_Trade_lvl,Symb_digit))
                                 TradeSignalfl = -1;

                             }
                           if((bool)(inReversePositionfl & 0x2) && (BUtrigedfl > 0))
                             {
                              IsTradeSituationChosen = 0;
                              IsLvlToched = 1;

                              IsDirTradefl = 0x4;
                              //IsOtskokfl = false;
                              //IsProboyfl = true;
                              //IsOutOfBarfl = false;

                             }
                           if((bool)(inReversePositionfl & 0x4) && (BUtrigedfl < 0))
                             {
                              IsTradeSituationChosen = 0;
                              IsLvlToched = -1;
                              IsDirTradefl = 0x2;
                              //IsOtskokfl = true;
                              //IsProboyfl = false;
                              //IsOutOfBarfl = false;

                             }
                          }
                     isPositionOpenfl =0;
                     Trade_a_Period_Quantity ++;
                    }


                 }
               isPositionOpenfl = 0;
               // if(Trade_a_Period_Quantity > 0)
               // IsTradeSituationChosen = 0;

              }


            //else
            if(Trade_a_Period_Quantity > 0)

              {
               // if(InnerBar_signal){
               if(!OrderTotalBySymb(_Symbol, Magic_num))
                 {
                  // if((IsTradeSituationChosen >0) && inProboyfl){
                  if((TradeSignalfl > 0)/* && (inOutOfBarfl?(CurPeriod_Trade_lvl > CurPeriod_Aver_lvl):true)*/)
                    {
                     //if(inSLbyChanal){
                     //   Set_Buy_Order(_Symbol, inLot, CurPeriod_Trade_lvl + inLuft*Symb_Point,
                     //              CurPeriod_Stop_lvl + inLuft*Symb_Point - inSLadd*Symb_Point, CurTP, t_m + (PeriodSeconds(PERIOD_H1)*22), Magic_num, ""); /* 1320 - *22часа*/}
                     //else{
                     Set_Buy_Order(_Symbol, inLot, CurPeriod_Trade_lvl + inLuft*Symb_Point,
                                   CurSL+ inLuft, CurTP, t_m + (PeriodSeconds(PERIOD_H1)*22), Magic_num, ""); /* 1320 - *22часа*/
                                   //}
                     Trade_a_Period_Quantity--;
                     TradeSignalfl = 0;
                     TradeSignalModfl = 0;
                     isPositionOpenfl = 0;
                     //IsTradeSituationChosen = 0;
                     //Reverse_a_Period_Quantity = inQu_of_Reverse_a_Trade;
                     isOrderPlacedfl = true;
                     BUplusfl = inBUplusfl;
                     BUminusfl = inBUminusfl;
                     BUtrigedfl = 0;
                     MoveTPBUfl = inMoveTPBUfl;
                     isRevPosAllowfl = inReversePositionfl /*inReverseIfSL || inReverseIfBUplus|| inReverseIfBUminus*/;
                     TrlSLfl = inTrlSLfl;
                     TrlSLlvl = inTrlSLstepLvl;
                     PosTimeLim = inPosTimeLim;

                    }
                  if((TradeSignalfl < 0)  /* && (inOutOfBarfl?(CurPeriod_Trade_lvl < CurPeriod_Aver_lvl):true)*/)
                    {
                     //if(inSLbyChanal){
                     //   Set_Sell_Order(_Symbol, inLot, CurPeriod_Trade_lvl - inLuft*Symb_Point,
                     //              CurPeriod_Stop_lvl - inLuft*Symb_Point + inSLadd*Symb_Point, CurTP, t_m + (PeriodSeconds(PERIOD_H1)*22), Magic_num, ""); /* 1320 - *22часа*/}
                     //else{
                     Set_Sell_Order(_Symbol, inLot, CurPeriod_Trade_lvl - inLuft*Symb_Point,
                                    CurSL - inLuft, CurTP, t_m + (PeriodSeconds(PERIOD_H1)*22), Magic_num, "");/* 1320 - *22часа*/
                      //  }
                     Trade_a_Period_Quantity--;
                     TradeSignalfl = 0;
                     TradeSignalModfl = 0;
                     isPositionOpenfl = 0;
                     //IsTradeSituationChosen = 0;
                     //Reverse_a_Period_Quantity = inQu_of_Reverse_a_Trade;
                     isOrderPlacedfl = true;
                     BUplusfl = inBUplusfl;
                     BUminusfl = inBUminusfl;
                     BUtrigedfl = 0;
                     MoveTPBUfl = inMoveTPBUfl;
                     isRevPosAllowfl = inReversePositionfl /*inReverseIfSL || inReverseIfBUplus|| inReverseIfBUminus*/;
                     TrlSLfl = inTrlSLfl;
                     TrlSLlvl = inTrlSLstepLvl;
                     PosTimeLim = inPosTimeLim;

                    }
                 } //(!OrderTotalBySymb(_Symbol))
               else
                 {
                  //if(iOpen(NULL,in1mTradePeriod?PERIOD_M1:PERIOD_M5,0) > CurPeriod_Trade_lvl){
                     if(LastCandleH > CurPeriod_Cancel_lvl_H){
                           CancelAllPendingOrderBySymb(_Symbol, Magic_num);
                           Print("Одер отменен из-за пробития уровня отмены H");
                          // Print("iHigh = ",iHigh(NULL,in1mTradePeriod?PERIOD_M1:PERIOD_M5,1));
                           Print("LastCandleH = ",LastCandleH);
                           Print("текущий CurPeriod_Cancel_lvl_H: ", CurPeriod_Cancel_lvl_H);
                           IsLvlToched = 0;
                           IsTradeSituationChosen = 0;
                     
                     } 
                  
                  
                  
                  
                  
                    if(LastCandleL < CurPeriod_Cancel_lvl_L){
                     // if(!(AllowedTime(_Symbol,inStartTradingTimeU,inStopTradingTimeU,t_m,inCloseForNightfl,inCloseForWeekendfl,inClzForContrChange,inClzForWar)))
                     //  {
                     CancelAllPendingOrderBySymb(_Symbol, Magic_num);
                     

                     Print("Одер отменен из-за пробития уровня отмены L");
                    // Print("iLow = ",iLow(NULL,in1mTradePeriod?PERIOD_M1:PERIOD_M5,1));
                     Print("LastCandleL = ",LastCandleL);
                     Print("текущий CurPeriod_Cancel_lvl_L: ", CurPeriod_Cancel_lvl_L);
                     IsLvlToched = 0;
                     IsTradeSituationChosen = 0;
                     //  }
                     //InnerBar_signal = 0; //не сбрасываем, что бы отрабатывать уровень в др. сторону
                    }
                  //if(iLow(NULL,in1mTradePeriod?PERIOD_M1:PERIOD_M5,1) < CurPeriod_Cancel_lvl_L){
                  //      CancelAllPendingOrderBySymb(_Symbol);
                  //      IsLvlToched = 0;
                  //      IsTradeSituationChosen = 0;
                  //}
                  //}

                 } //else(!OrderTotalBySymb(_Symbol))
               // } //(InnerBar_signal )

              }   //(Trade_a_Period_Quantity > 0)
           } //(AllowedTime(inStartTradingTimeU,inStopTradingTimeU))
         else
           {
            if(isOrderPlacedfl)
              {
               //if(isPositionOpenfl) isPositionOpenfl = false;

               if(CancelAllPendingOrderBySymb(_Symbol, Magic_num))
                 {
                  isOrderPlacedfl = false;
                  Print("Одер отменен из-за из-за истечения AllowedTime");
                 }
               else
                 {
                  t_m = 0;
                  return;
                 }

              }
            InnerBar_signal = 0;
            CurPeriod_High_lvl = 0;
            CurPeriod_Low_lvl = 0;
            CurPeriod_Trade_lvl = 0;
            IsLvlToched = 0;
            IsTradeSituationChosen = 0;
            LastSL = 0;

           }



      //      //&&(CurTick_Date.hour>=23))
      //datetime sd = 0;
      //datetime cd = 0;
      //SymbolInfoSessionTrade(_Symbol,FRIDAY,0,sd,cd);
      //if(TimeCurrent() > cd - PeriodSeconds(PERIOD_M30))
      //   CloseAllPositionsBySymb(_Symbol);

      //(isOrderPlacedfl)
      // }// (InnerBar_signal)




      //if(isOrderPlacedfl && )




     } // (t_m != iTime(NULL,PERIOD_M1,0))

  } // OnTick()
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool isDayAllowed(datetime cur_per)
  {
   MqlDateTime M_d;
   TimeToStruct(cur_per, M_d);
   int cd = M_d.day_of_week;
   switch(cd)
     {
      case 1:
         return isDayMonAllowed;
      case 2:
         return isDayTueAllowed;
      case 3:
         return isDayWenAllowed;
      case 4:
         return isDayThuAllowed;
      case 5:
         return isDayFriAllowed;
      default:
         return false;

     }

  }
//+------------------------------------------------------------------+
