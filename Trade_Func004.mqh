//+------------------------------------------------------------------+
//|                                           MyFirstIncludeFile.mqh |
//|                                                  dilettantcorner |
//|                                        dilettantcorner@gmail.com |
//+------------------------------------------------------------------+
#property copyright "dilettantcorner"
#property link      "dilettantcorner@gmail.com"

#define TradeLVLsize 6

struct trdlvl {double price; char width; datetime formtime;};

//+-----------------------------------------------------------------------------+
//bool Close_Position(ulong position, int slipage);
//Функция закытия позиции с рынка
//position указывает на позицию, которую требуется закрыть
//slipage допустимое проскальзывание от текущей рыночной котировки в пунктах
//+-----------------------------------------------------------------------------+

//Открытие позиции на Бай, или установка отложенного ордера на Бай
//Если параметр open_price = 0 - открывается позиция, если больше нуля - устанавливается
//отложенный ордер. Тип ордера зависит от положения точки open_price относительно текущей цены Аск
//symbol - имя торгового инструмента , lot - объем входа , уровень установки отложенного ордера
//stop_loss - величина стоп-приказа типа Стоп Лосс в пунктах. Не используется при открытии позиции и при значении 0(нуль)
//take_profit - величина стоп-приказа типа Тейк Профит в пунктах. Не используется при открытии позиции и при значении 0(нуль)
//magic - идентификатор торгового робота , comment - комментарий , slipage - допустимое отклонение от запраиваемой цены
/*long Open_Buy_Pos(string symbol,double lot, double open_price, uint stop_loss, uint take_profit, uint magic, string comment, int slipage)
{
   //Создание структур запроса и ответа для торгового сервера
   MqlTradeRequest reqwest;
   MqlTradeResult result;
   
   //Предварительное обнуление всех полей структур запроса и ответа
   ZeroMemory(reqwest);
   ZeroMemory(result);
   
   //Заполнение структуры запроса
   reqwest.symbol = symbol;
   
   //Сохраняем последнюю известную цену Аск для тороговых операций
   double current_ask = SymbolInfoDouble(reqwest.symbol,SYMBOL_ASK);
   
   //Открытие позиции
   if (open_price <= 0) 
   {
      //Поле запроса, отвечающее за тип операции
      reqwest.action = TRADE_ACTION_DEAL;
      
      //Поле запроса, отвечающее направление операции
      reqwest.type = ORDER_TYPE_BUY;
      
      //Поле запроса, по какой цене осуществляется вход
      reqwest.price = current_ask;
      
      //Поля СЛ и ТП. При открытии позиции не используются
      reqwest.sl = 0;
      reqwest.tp = 0;
   }
   else
   {
      //Установка отложенного ордера
      reqwest.action = TRADE_ACTION_PENDING;
      reqwest.price = open_price;
      
      //Служебное значение уровня Stop Level для проверки правильности установки стоп-приказов
      long stop_level = SymbolInfoInteger(symbol,SYMBOL_TRADE_STOPS_LEVEL);
      
      //Если стоп-приказ типа Стоп Лосс задействован
      if(stop_loss > 0)
      {
         //Проверка соответствия размера СЛ ограничению Stop Level
         if(stop_loss < stop_level) stop_loss = (uint)stop_level;
         
         //Установка уровня СЛ
         reqwest.sl = NormalizeDouble(reqwest.price - stop_loss * _Point,_Digits);
      }
      //Если стоп-приказ типа Тейк Профит задействован
      if(take_profit > 0)
      {
         //Проверка соответствия размера ТП ограничению Stop Level
         if(take_profit < stop_level) take_profit = (uint)stop_level;
         
         //Установка уровня ТП
         reqwest.tp = NormalizeDouble(reqwest.price + take_profit * _Point,_Digits);
      }
      //Указываем тип отложенного торгового приказа путем проверки
      //положения требуемой цены открытия относительно текущей цены Аск
      if (open_price > current_ask) reqwest.type = ORDER_TYPE_BUY_STOP;
      else reqwest.type = ORDER_TYPE_BUY_LIMIT;

   }
   //Установка объема будущей позиции или ордера
   reqwest.volume = lot;
   
   //Установка политики заполнения объема (на Forex используется только указанный)
   reqwest.type_filling = ORDER_FILLING_FOK;
   
   //Поле комментария. Если востребовано
   if(comment != NULL && comment != "") reqwest.comment = comment;
   
   //Поле идентификатора торгового эксперта. Если востребовано
   if(magic > 0) reqwest.magic = magic;
   
   //Поле возможного проскальзывания. Если востребовано
   if(slipage > 0) reqwest.deviation = slipage;
   
   //Отправка запроса на сервер. При неудаче повторям запрос при помощи цикла
   for(int i = 0;i < 10;i++)
   {
      //Функция отправки торгового запроса. Отправляется ранее
      //заполненная структура запроса и пустой "бланк" ответа для торгового сервера
      if(!OrderSend(reqwest,result))
      {
         //Если запрос отклонен - вывод в журнал сообщения об ошибке.
         //Идентификатор ошибки возвращает в виде заполненной структуры ответа торговго сервера.
         //в поле result.retcode
         Print("Позиция или ордер Селл не открыт. Ошибка №",result.retcode);
         
         //Время в милисекундах перед следующей попыткой
         Sleep(500);
      }
      else
      {
         //Если запрос исполнен торговым сервером анализируем структуру его ответа
         //Извлекаем из ответа сервера уникальный идентификатор сделки
         ulong deal_ticket = result.deal;
         
         //Если сделка не состоялась, но выставлен отложенный ордер идентификатор сделки
         //будет равен нулю. В этом случае выходим из цикла
         if(deal_ticket == 0) break;
         
         if(deal_ticket > 0)
         {
            //Если сделка состоялась 
            if(HistoryDealSelect(deal_ticket))
            {
               //Считываем уникальный идентификатор позиции, частью которой является сделка
               long pos_ticket = HistoryDealGetInteger(deal_ticket,DEAL_POSITION_ID);
               
               //И возвращаем во внешнюю функцию уникальный идентификатор сделки
               return pos_ticket;
            }
         }
      }
   }
   
   //Если по результатам работы функции сделка не открыта, во внешнюю функцию возвращается
   //значение -1, которое считается бесполезным
   return -1;
}*/

//bool AllowedTime(string start_time, string stop_time){
//   datetime dt_start_time = StringToTime(start_time);
//   datetime dt_stop_time = StringToTime(stop_time);
//   
//   if(dt_start_time < dt_stop_time){
//         return (TimeCurrent() >= dt_start_time && TimeCurrent() < dt_stop_time);
//   }
//   else if(dt_start_time > dt_stop_time){
//         return ((TimeCurrent() >= dt_start_time && TimeCurrent() < StringToTime("23:59:59"))||
//               (TimeCurrent() >= StringToTime("00:00:00") && TimeCurrent() < dt_stop_time));
//   }
//   return false;
//
//}
bool FofbiddenTime(ushort start_time, ushort stop_time){
   if(start_time == 0 && stop_time == 0) return true;
   
   int hours = (int)(start_time /100);
   if(hours < 0) hours = 0;
   if(hours > 23) hours = 23;
   int minutes = (int)(start_time % 100);
   if(minutes < 0) minutes = 0;
   if(minutes > 59) minutes = 59;
   string str_start_time = IntegerToString(hours) +":" + IntegerToString(minutes);
   
    hours = (int)(stop_time /100);
   if(hours < 0) hours = 0;
   if(hours > 23) hours = 23;
    minutes = (int)(stop_time % 100);
   if(minutes < 0) minutes = 0;
   if(minutes > 59) minutes = 59;
   string str_stop_time = IntegerToString(hours) +":" + IntegerToString(minutes);
   
   datetime dt_start_time = StringToTime(str_start_time);
   datetime dt_stop_time = StringToTime(str_stop_time);
   
   if(dt_start_time < dt_stop_time){
         return !(TimeCurrent() >= dt_start_time && TimeCurrent() < dt_stop_time);
   }
   else if(dt_start_time > dt_stop_time){
         return !((TimeCurrent() >= dt_start_time && TimeCurrent() < StringToTime("23:59:59"))||
               (TimeCurrent() >= StringToTime("00:00:00") && TimeCurrent() < dt_stop_time));
   }
   return true;

   
}

bool AllowedTime(ushort start_time, ushort stop_time, datetime dt_cur_time, bool ClzForNight, bool ClzForWeekend,/* bool ClzForContrChange,*/ bool ClzForWar){ //HHMM
   MqlDateTime sct_cur_time;
   TimeToStruct(dt_cur_time,sct_cur_time);
   if(ClzForNight){
      
        //TimeToStruct(dt_cur_time,sct_cur_time);
        if(sct_cur_time.hour >=23)
            return false;
   }
   if(ClzForWeekend){
     // MqlDateTime sct_cur_time;
        //TimeToStruct(dt_cur_time,sct_cur_time);
        if((sct_cur_time.day_of_week == 5)&&(sct_cur_time.hour >=22))
            return false;
   }
   if(ClzForWar){
     // MqlDateTime sct_cur_time;
       // TimeToStruct(dt_cur_time,sct_cur_time);
       if((sct_cur_time.year == 2022)&&((sct_cur_time.day_of_year>50)&&(sct_cur_time.day_of_year<90)))
         return false;
   
   }
   //if(ClzForContrChange){
   //   if(sct_cur_time.day >= 30)
   //   return false;
   //}
   
   if(start_time == 0 && stop_time == 0) return true;

   int hours = (int)(start_time /100);
   if((hours < 0)) hours = 0; //||(hours == 24)
   if(hours > 23) hours = 23;
   int minutes = (int)(start_time % 100);
   if(minutes < 0) minutes = 0;
   if(minutes > 59) minutes = 59;
   string str_start_time = IntegerToString(hours) +":" + IntegerToString(minutes);
   
    hours = (int)(stop_time /100);
   if(hours < 0) hours = 0;
   if(hours > 23) hours = 23;
    minutes = (int)(stop_time % 100);
   if(minutes < 0) minutes = 0;
   if(minutes > 59) minutes = 59;
   string str_stop_time = IntegerToString(hours) +":" + IntegerToString(minutes);
   
   datetime dt_start_time = StringToTime(str_start_time);
   datetime dt_stop_time = StringToTime(str_stop_time);
   //datetime dt_cur_time = TimeCurrent();
   if(dt_start_time < dt_stop_time){
         return ((dt_cur_time >= dt_start_time) && (dt_cur_time < dt_stop_time));
   }
   else if(dt_start_time > dt_stop_time){
         return (((dt_cur_time >= dt_start_time) && (dt_cur_time < StringToTime("23:59:59")))||
               ((dt_cur_time >= StringToTime("00:00:00")) && (dt_cur_time < dt_stop_time)));
   }
   return false;

}


bool AllowedTime(string Symb, ushort start_time, ushort stop_time, datetime dt_cur_time, bool ClzForNight, bool ClzForWeekend, char ClzForContrChange, bool ClzForWar){ //HHMM
   MqlDateTime sct_cur_time;
   TimeToStruct(dt_cur_time,sct_cur_time);
   if(ClzForNight){
      
        //TimeToStruct(dt_cur_time,sct_cur_time);
        if(sct_cur_time.hour >=23){
            //Print("AllowedTime false -> ClzForNight");
            return false;
        }
   }
   if(ClzForWeekend){
     // MqlDateTime sct_cur_time;
        //TimeToStruct(dt_cur_time,sct_cur_time);
        //if(sct_cur_time.day_of_week == 5){
        if((sct_cur_time.day_of_week == 5)&&(sct_cur_time.hour >=15)){
            //Print("AllowedTime false -> ClzForWeekend");
            return false;
        }
   }
   if(ClzForWar){
     // MqlDateTime sct_cur_time;
       // TimeToStruct(dt_cur_time,sct_cur_time);
       if((sct_cur_time.year == 2022)&&((sct_cur_time.day_of_year>50)&&(sct_cur_time.day_of_year<90))){
           //Print("AllowedTime false -> ClzForWar");
            return false;
       }
   
   }
   //if(ClzForContrChange){
   //   if(sct_cur_time.mon == 2){
   //      if(sct_cur_time.day >= 28)
   //      return false;
   //   }
   //   else{   
   //       if(sct_cur_time.day >= 30)
   //          return false;
   //   }
   //}
   switch(ClzForContrChange){
         case -1 :{
                     if( dt_cur_time > (SymbolInfoInteger(Symb,SYMBOL_EXPIRATION_TIME) - (PeriodSeconds(PERIOD_H1)*24))){
                           //Print("AllowedTime false -> ClzForContrChange_-1");   
                           return false;
                     }
                     break; 
                 }
         case 0 :{break;}
         case 1 :{
                     if((sct_cur_time.day >= 27)&&(sct_cur_time.day <= 28)){
                           //Print("AllowedTime false -> ClzForContrChange_1");
                            return false;
                         } 
                   break; 
                 }
          case 2 :{
                     if(sct_cur_time.mon == 2){
                        if(sct_cur_time.day >= 28){
                             //Print("AllowedTime false -> ClzForContrChange_2.1");
                             return false;
                        }     
                     }
                     else{   
                         if(sct_cur_time.day >= 30){
                              //Print("AllowedTime false -> ClzForContrChange_2.2");
                            return false;
                         }   
                     }
                    break;                      
                  }
          case 3 :{
                     if((sct_cur_time.mon == 3)||(sct_cur_time.mon == 6)||(sct_cur_time.mon == 9)||(sct_cur_time.mon == 12)){
                        if((sct_cur_time.day >= 16)&&(sct_cur_time.day <= 17)){
                              //Print("AllowedTime false -> ClzForContrChange_3");
                              return false;
                        }
                     }
                     break; 
                  }
          case 4 :{
                     if( dt_cur_time > (SymbolInfoInteger(Symb,SYMBOL_EXPIRATION_TIME) - (PeriodSeconds(PERIOD_H1)*24))){
                          //Print("AllowedTime false -> ClzForContrChange_4");   
                           return false;
                     }
                     break; 
                  }
          case 5 :{
               if(sct_cur_time.year == 2023){
                  if((sct_cur_time.mon == 3) && (sct_cur_time.day == 29))
                     return false;
                  if((sct_cur_time.mon == 4) && (sct_cur_time.day == 26))   
                     return false;
                  if((sct_cur_time.mon == 5) && (sct_cur_time.day == 26))
                     return false;
                  if((sct_cur_time.mon == 6) && (sct_cur_time.day == 28))
                     return false;
                  if((sct_cur_time.mon == 7) && (sct_cur_time.day == 27))
                     return false;
                  if((sct_cur_time.mon == 8) && (sct_cur_time.day == 29))
                     return false;
                  if((sct_cur_time.mon == 9) && (sct_cur_time.day == 27))
                     return false;
                  if((sct_cur_time.mon == 10) && (sct_cur_time.day == 27))
                     return false;
                  if((sct_cur_time.mon == 11) && (sct_cur_time.day == 28))
                     return false;
                  if((sct_cur_time.mon == 12) && (sct_cur_time.day == 27))
                     return false;
                  
               
               }
               if(sct_cur_time.year == 2024){
                  if((sct_cur_time.mon == 1) && (sct_cur_time.day == 29))
                     return false;
                  if((sct_cur_time.mon == 2) && (sct_cur_time.day == 27))
                     return false;
                  if((sct_cur_time.mon == 3) && (sct_cur_time.day == 26))
                     return false;
                  if((sct_cur_time.mon == 4) && (sct_cur_time.day == 26))   
                     return false;
                  if((sct_cur_time.mon == 5) && (sct_cur_time.day == 29)) 
                     return false;
               }
                
         
         break;
         }                  
          default : break;                  
      
      } //switch(inCloseForContrChngfl){
   
   if(start_time == 0 && stop_time == 0) return true;

   int hours = (int)(start_time /100);
   if((hours < 0)) hours = 0; //||(hours == 24)
   if(hours > 23) hours = 23;
   int minutes = (int)(start_time % 100);
   if(minutes < 0) minutes = 0;
   if(minutes > 59) minutes = 59;
   string str_start_time = IntegerToString(hours) +":" + IntegerToString(minutes);
   
    hours = (int)(stop_time /100);
   if(hours < 0) hours = 0;
   if(hours > 23) hours = 23;
    minutes = (int)(stop_time % 100);
   if(minutes < 0) minutes = 0;
   if(minutes > 59) minutes = 59;
   string str_stop_time = IntegerToString(hours) +":" + IntegerToString(minutes);
   
   datetime dt_start_time = StringToTime(str_start_time);
   datetime dt_stop_time = StringToTime(str_stop_time);
   //datetime dt_cur_time = TimeCurrent();
   if(dt_start_time < dt_stop_time){
         return ((dt_cur_time >= dt_start_time) && (dt_cur_time < dt_stop_time));
   }
   else if(dt_start_time > dt_stop_time){
         return (((dt_cur_time >= dt_start_time) && (dt_cur_time < StringToTime("23:59:59")))||
               ((dt_cur_time >= StringToTime("00:00:00")) && (dt_cur_time < dt_stop_time)));
   }
   Print("AllowedTime false -> Out of time range");
   return false;

}

//+------------------------------------------------------------------+
//Разделяем механизмы отправки отложенных ордеров и открытия позиций
//В новом варианте функции открытия позиции нет пформальных параметров под цены открытия, стопа и тейка
long Open_Buy_Pos(string symbol,double lot, uint magic, string comment, int slipage)
{
   MqlTradeRequest reqwest;
   MqlTradeResult result;
   
   ZeroMemory(reqwest);
   ZeroMemory(result);
   
   //Поля торгового запроса, обязательные для открытия позиций
   //при всех режимах исполнения сделок
   reqwest.action = TRADE_ACTION_DEAL;
   reqwest.symbol = symbol;
   reqwest.type = ORDER_TYPE_BUY;
   reqwest.volume = lot;
   reqwest.type_filling = ORDER_FILLING_FOK;
   
   //Поля торгового запроса, обязательные в режимах исполнения сделок
   //Instant и Request. Можно не трогать в других режимах исполнения сделок
   //if(SymbolInfoInteger(reqwest.symbol,SYMBOL_TRADE_EXEMODE) == SYMBOL_TRADE_EXECUTION_INSTANT ||
   //   SymbolInfoInteger(reqwest.symbol,SYMBOL_TRADE_EXEMODE) == SYMBOL_TRADE_EXECUTION_REQUEST)
   //{
      double current_ask = SymbolInfoDouble(reqwest.symbol,SYMBOL_ASK);
      reqwest.price = current_ask;
      reqwest.sl = 0;
      reqwest.tp = 0;
      reqwest.deviation = slipage;
   //}
   
   //Не обязательные поля запроса
   if(comment != NULL && comment != "") reqwest.comment = comment;
   if(magic > 0) reqwest.magic = magic;
   
   
   for(int i = 0;i < 10;i++)
   {
      if(!OrderSend(reqwest,result))
      {
         Print("Позиция Бай не открыта. Ошибка №",result.retcode);
         Sleep(500);
      }
      else
      {
         ulong deal_ticket = result.deal;
         
         if(deal_ticket == 0) break;
         
         if(deal_ticket > 0)
         { 
            if(HistoryDealSelect(deal_ticket))
            {
               long pos_ticket = HistoryDealGetInteger(deal_ticket,DEAL_POSITION_ID);
               
               return pos_ticket;
            }
         }
      }
   }
   
   return -1;
}
//+------------------------------------------------------------------+
long Set_Buy_Order(string symbol,
                   double lot, 
                   double open_price, 
                   int stop_loss, 
                   int take_profit, 
                   datetime expiration_time, 
                   uint magic, 
                   string comment)
{
   MqlTradeRequest reqwest;
   MqlTradeResult result;
   
   ZeroMemory(reqwest);
   ZeroMemory(result);
   
   reqwest.action = TRADE_ACTION_PENDING;
   reqwest.symbol = symbol;
   reqwest.volume = lot;
   //reqwest.action = TR
   reqwest.type_filling = ORDER_FILLING_RETURN;
   
   int digits = (int)SymbolInfoInteger(reqwest.symbol,SYMBOL_DIGITS);
   reqwest.price = NormalizeDouble(open_price,digits);
   double current_ask = SymbolInfoDouble(reqwest.symbol,SYMBOL_ASK);
   if(reqwest.price > current_ask) return -1; //reqwest.type = ORDER_TYPE_BUY_STOP;
   else reqwest.type = ORDER_TYPE_BUY_LIMIT;
   
   int stop_level = (int)SymbolInfoInteger(reqwest.symbol,SYMBOL_TRADE_STOPS_LEVEL);
   double point = SymbolInfoDouble(reqwest.symbol,SYMBOL_POINT);
   if(stop_loss > 0)
   {
      if(stop_loss < stop_level) stop_loss = stop_level;
      reqwest.sl = NormalizeDouble(reqwest.price - stop_loss * point,digits);
   }
   else reqwest.sl = 0;
   
   if(take_profit > 0)
   {
      if(take_profit < stop_level) take_profit = stop_level;
      reqwest.tp = NormalizeDouble(reqwest.price + take_profit * point,digits);
   }
   else reqwest.tp = 0;
   
   reqwest.type_time = ORDER_TIME_GTC;
   //reqwest.expiration = expiration_time;
   
   if(comment != NULL && comment != "") reqwest.comment = comment;
   if(magic > 0) reqwest.magic = magic;
   
   
   for(int i = 0;i < 10;i++)
   {
      if(!OrderSend(reqwest,result))
      {
         Print("Отложенный ордер Бай не установлен. Ошибка №",result.retcode);
         Sleep(500);
      }
      else
      {
         ulong order_ticket = result.order;
         
         if(order_ticket > 0) return (long)order_ticket;
      }
   }
   
   return -1;
}
//+------------------------------------------------------------------+
long Set_Buy_Order(string symbol,
                   double lot, 
                   double open_price, 
                   double stop_loss, 
                   int take_profit, 
                   datetime expiration_time, 
                   uint magic, 
                   string comment)
{
   MqlTradeRequest reqwest;
   MqlTradeResult result;
   
   ZeroMemory(reqwest);
   ZeroMemory(result);
   
   reqwest.action = TRADE_ACTION_PENDING;
   reqwest.symbol = symbol;
   reqwest.volume = lot;
   //reqwest.action = TR
   reqwest.type_filling = ORDER_FILLING_RETURN;
   
   int digits = (int)SymbolInfoInteger(reqwest.symbol,SYMBOL_DIGITS);
   reqwest.price = NormalizeDouble(open_price,digits);
   double current_ask = SymbolInfoDouble(reqwest.symbol,SYMBOL_ASK);
   if(reqwest.price > current_ask) return -1; //reqwest.type = ORDER_TYPE_BUY_STOP;
   else reqwest.type = ORDER_TYPE_BUY_LIMIT;
   
   int stop_level = (int)SymbolInfoInteger(reqwest.symbol,SYMBOL_TRADE_STOPS_LEVEL);
   double point = SymbolInfoDouble(reqwest.symbol,SYMBOL_POINT);
   if(stop_loss > 0)
   {
      if((open_price - stop_loss)/point < stop_level) stop_loss = open_price - stop_level * point;
      reqwest.sl = NormalizeDouble(stop_loss,digits);
   }
   else reqwest.sl = 0;
   
   if(take_profit > 0)
   {
      if(take_profit < stop_level) take_profit = stop_level;
      reqwest.tp = NormalizeDouble(reqwest.price + take_profit * point,digits);
   }
   else reqwest.tp = 0;
   
   reqwest.type_time = ORDER_TIME_GTC;
   //reqwest.expiration = expiration_time;
   
   if(comment != NULL && comment != "") reqwest.comment = comment;
   if(magic > 0) reqwest.magic = magic;
   
   
   for(int i = 0;i < 10;i++)
   {
      if(!OrderSend(reqwest,result))
      {
         Print("Отложенный ордер Бай не установлен. Ошибка №",result.retcode);
         Sleep(500);
      }
      else
      {
         ulong order_ticket = result.order;
         
         if(order_ticket > 0) return (long)order_ticket;
      }
   }
   
   return -1;
}
//+------------------------------------------------------------------+
//Открытие позиции на Селл, или установка отложенного ордера на Селл
//Если параметр open_price = 0 - открывается позиция, если больше нуля - устанавливается
//отложенный ордер. Тип ордера зависит от положения точки open_price относительно текущей цены Бид
//symbol - имя торгового инструмента , lot - объем входа , уровень установки отложенного ордера
//stop_loss - величина стоп-приказа типа Стоп Лосс в пунктах. Не используется при открытии позиции и при значении 0(нуль)
//take_profit - величина стоп-приказа типа Тейк Профит в пунктах. Не используется при открытии позиции и при значении 0(нуль)
//magic - идентификатор торгового робота , comment - комментарий , slipage - допустимое отклонение от запраиваемой цены
/*long Open_Sell_Pos(string symbol,double lot, double open_price, uint stop_loss, uint take_profit, uint magic, string comment, int slipage)
{
   MqlTradeRequest reqwest;
   MqlTradeResult result;
   
   ZeroMemory(reqwest);
   ZeroMemory(result);
   
   reqwest.symbol = symbol;
   double current_bid = SymbolInfoDouble(reqwest.symbol,SYMBOL_BID);
   if (open_price <= 0) 
   {
      reqwest.action = TRADE_ACTION_DEAL;
      reqwest.type = ORDER_TYPE_SELL;
      reqwest.price = current_bid;
      reqwest.sl = 0;
      reqwest.tp = 0;
   }
   else
   {
      reqwest.action = TRADE_ACTION_PENDING;
      reqwest.price = open_price;
      long stop_level = SymbolInfoInteger(symbol,SYMBOL_TRADE_STOPS_LEVEL);
      if(stop_loss > 0)
      {
         if(stop_loss < stop_level) stop_loss = (uint)stop_level;
         reqwest.sl = NormalizeDouble(reqwest.price + stop_loss * _Point,_Digits);
      }
      if(take_profit > 0)
      {
         if(take_profit < stop_level) take_profit = (uint)stop_level;
         reqwest.tp = NormalizeDouble(reqwest.price - take_profit * _Point,_Digits);
      }
      if (open_price > current_bid) reqwest.type = ORDER_TYPE_SELL_LIMIT;
      else reqwest.type = ORDER_TYPE_SELL_STOP;


   }
   reqwest.volume = lot;
   reqwest.type_filling = ORDER_FILLING_FOK;
   if(comment != NULL && comment != "") reqwest.comment = comment;
   if(magic > 0) reqwest.magic = magic;
   if(slipage > 0) reqwest.deviation = slipage;
   
   for(int i = 0;i < 10;i++)
   {
      if(!OrderSend(reqwest,result))
      {
         Print("Позиция или ордер Селл не открыт. Ошибка №",result.retcode);
         Sleep(500);
      }
      else
      {
         ulong deal_ticket = result.deal;
         if(deal_ticket == 0) break;
         if(deal_ticket > 0)
         {
            if(HistoryDealSelect(deal_ticket))
            {
               long pos_ticket = HistoryDealGetInteger(deal_ticket,DEAL_POSITION_ID);
               return pos_ticket;
            }
         }
      }
   }
   
   return -1;
}*/
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
long Open_Sell_Pos(string symbol,double lot, uint magic, string comment, int slipage)
{
   MqlTradeRequest reqwest;
   MqlTradeResult result;
   
   ZeroMemory(reqwest);
   ZeroMemory(result);
   
   reqwest.action = TRADE_ACTION_DEAL;
   reqwest.symbol = symbol;
   reqwest.type = ORDER_TYPE_SELL;
   reqwest.volume = lot;
   reqwest.type_filling = ORDER_FILLING_FOK;
   

   //if(SymbolInfoInteger(reqwest.symbol,SYMBOL_TRADE_EXEMODE) == SYMBOL_TRADE_EXECUTION_INSTANT ||
   //   SymbolInfoInteger(reqwest.symbol,SYMBOL_TRADE_EXEMODE) == SYMBOL_TRADE_EXECUTION_REQUEST)
   //{
      double current_bid = SymbolInfoDouble(reqwest.symbol,SYMBOL_BID);
      reqwest.price = current_bid;
      reqwest.sl = 0;
      reqwest.tp = 0;
      reqwest.deviation = slipage;
   //}
   
   if(comment != NULL && comment != "") reqwest.comment = comment;
   if(magic > 0) reqwest.magic = magic;
   
   
   for(int i = 0;i < 10;i++)
   {
      if(!OrderSend(reqwest,result))
      {
         Print("Позиция Селл не открыта. Ошибка №",result.retcode);
         Sleep(500);
      }
      else
      {
         ulong deal_ticket = result.deal;
         
         if(deal_ticket == 0) break;
         
         if(deal_ticket > 0)
         { 
            if(HistoryDealSelect(deal_ticket))
            {
               long pos_ticket = HistoryDealGetInteger(deal_ticket,DEAL_POSITION_ID);
               
               return pos_ticket;
            }
         }
      }
   }
   
   return -1;
}
//+------------------------------------------------------------------+
long Set_Sell_Order(string symbol,
                   double lot, 
                   double open_price, 
                   int stop_loss, 
                   int take_profit, 
                   datetime expiration_time, 
                   uint magic, 
                   string comment)
{
   MqlTradeRequest reqwest;
   MqlTradeResult result;
   
   ZeroMemory(reqwest);
   ZeroMemory(result);
   
   reqwest.action = TRADE_ACTION_PENDING;
   reqwest.symbol = symbol;
   reqwest.volume = lot;
   reqwest.type_filling = ORDER_FILLING_RETURN;
   
   int digits = (int)SymbolInfoInteger(reqwest.symbol,SYMBOL_DIGITS);
   reqwest.price = NormalizeDouble(open_price,digits);
   double current_bid = SymbolInfoDouble(reqwest.symbol,SYMBOL_BID);
   if(reqwest.price < current_bid) return -1; //reqwest.type = ORDER_TYPE_SELL_STOP;
   else reqwest.type = ORDER_TYPE_SELL_LIMIT;
   
   int stop_level = (int)SymbolInfoInteger(reqwest.symbol,SYMBOL_TRADE_STOPS_LEVEL);
   double point = SymbolInfoDouble(reqwest.symbol,SYMBOL_POINT);
   if(stop_loss > 0)
   {
      if(stop_loss < stop_level) stop_loss = stop_level;
      reqwest.sl = NormalizeDouble(reqwest.price + stop_loss * point,digits);
   }
   else reqwest.sl = 0;
   
   if(take_profit > 0)
   {
      if(take_profit < stop_level) take_profit = stop_level;
      reqwest.tp = NormalizeDouble(reqwest.price - take_profit * point,digits);
   }
   else reqwest.tp = 0;
   
   reqwest.type_time = ORDER_TIME_GTC;
   //reqwest.expiration = expiration_time;
   
   if(comment != NULL && comment != "") reqwest.comment = comment;
   if(magic > 0) reqwest.magic = magic;
   
   
   for(int i = 0;i < 10;i++)
   {
      if(!OrderSend(reqwest,result))
      {
         Print("Отложенный ордер Селл не установлен. Ошибка №",result.retcode);
         Sleep(500);
      }
      else
      {
         ulong order_ticket = result.order;
         
         if(order_ticket > 0) return (long)order_ticket;
      }
   }
   
   return -1;
}
long Set_Sell_Order(string symbol,
                   double lot, 
                   double open_price, 
                   double stop_loss, 
                   int take_profit, 
                   datetime expiration_time, 
                   uint magic, 
                   string comment)
{
   MqlTradeRequest reqwest;
   MqlTradeResult result;
   
   ZeroMemory(reqwest);
   ZeroMemory(result);
   
   reqwest.action = TRADE_ACTION_PENDING;
   reqwest.symbol = symbol;
   reqwest.volume = lot;
   reqwest.type_filling = ORDER_FILLING_RETURN;
   
   int digits = (int)SymbolInfoInteger(reqwest.symbol,SYMBOL_DIGITS);
   reqwest.price = NormalizeDouble(open_price,digits);
   double current_bid = SymbolInfoDouble(reqwest.symbol,SYMBOL_BID);
   if(reqwest.price < current_bid) return -1; //reqwest.type = ORDER_TYPE_SELL_STOP;
   else reqwest.type = ORDER_TYPE_SELL_LIMIT;
   
   int stop_level = (int)SymbolInfoInteger(reqwest.symbol,SYMBOL_TRADE_STOPS_LEVEL);
   double point = SymbolInfoDouble(reqwest.symbol,SYMBOL_POINT);
   if(stop_loss > 0)
   {
      
      if((stop_loss - open_price)/point < stop_level) stop_loss = open_price + stop_level * point;
      reqwest.sl = NormalizeDouble(stop_loss ,digits);
   }
   else reqwest.sl = 0;
   
   if(take_profit > 0)
   {
      if(take_profit < stop_level) take_profit = stop_level;
      reqwest.tp = NormalizeDouble(reqwest.price - take_profit * point,digits);
   }
   else reqwest.tp = 0;
   
   reqwest.type_time = ORDER_TIME_GTC;
   //reqwest.expiration = expiration_time;
   
   if(comment != NULL && comment != "") reqwest.comment = comment;
   if(magic > 0) reqwest.magic = magic;
   
   
   for(int i = 0;i < 10;i++)
   {
      if(!OrderSend(reqwest,result))
      {
         Print("Отложенный ордер Селл не установлен. Ошибка №",result.retcode);
         Sleep(500);
      }
      else
      {
         ulong order_ticket = result.order;
         
         if(order_ticket > 0) return (long)order_ticket;
      }
   }
   
   return -1;
}
//+------------------------------------------------------------------+
//Модификация открытой позиции
//position - уникальный идентификатор требуемой позиции
//SL - новый размер стоп-приказа Стоп Лосс в пунктах. Если 0(нуль) - остается прежним
//TP - новый размер стоп-приказа Тейк Профит в пунктах. Если 0(нуль) - остается прежним
bool Position_SLTP(ulong position,int SL,int TP){
   //Проверка на наличие открытой позиции с указанным идентификатором
   if(PositionSelectByTicket(position))
   {
      //Считываем необходимые свойства позиции
      double pos_op = PositionGetDouble(POSITION_PRICE_OPEN);
      string pos_symb = PositionGetString(POSITION_SYMBOL);
      ulong pos_mag = PositionGetInteger(POSITION_MAGIC);
      
      //Считываем напрвление позиции
      //Все типы позиций объявлены в терминале в виде перечисления ENUM_POSITION_TYPE
      //Если это значение присваивается отдельной переменной, его обязательно нужно привести к типу перечисления ENUM_POSITION_TYPE
      ENUM_POSITION_TYPE pos_type = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
      
      //Считываем свойства торгового инструмента для дальнейих вычислений и проверок ограничения Frezze Level
      int symb_digits = (int)SymbolInfoInteger(pos_symb,SYMBOL_DIGITS);
      double symb_point = SymbolInfoDouble(pos_symb,SYMBOL_POINT);
      int freez_level = (int)SymbolInfoInteger(pos_symb,SYMBOL_TRADE_FREEZE_LEVEL);
      
      MqlTradeRequest reqwest;
      MqlTradeResult result;
   
      ZeroMemory(reqwest);
      ZeroMemory(result);
      
      if(pos_type == POSITION_TYPE_BUY)
      {
         if(SL > 0) 
         {
            //Если уровень Стоп Лосс подлежит изменению - новая его величина в пунктах не должна быть меньше ограничения Frezze Level
            if(SL < freez_level) SL = freez_level;
            
            reqwest.sl = NormalizeDouble(pos_op - SL * symb_point,symb_digits);
         }
         if(TP > 0)
         {
            //Если уровень Тейк Профит подлежит изменению - новая его величина в пунктах не должна быть меньше ограничения Frezze Level
            if(TP < freez_level) TP = freez_level;
            
            reqwest.tp = NormalizeDouble(pos_op + TP * symb_point,symb_digits);
         }
      }
      else
      {
         if(SL > 0)
         {
            if(SL < freez_level) SL = freez_level;
            reqwest.sl = NormalizeDouble(pos_op + SL * symb_point,symb_digits);
         }
         if(TP > 0)
         {
            if(TP < freez_level) TP = freez_level;
            reqwest.tp = NormalizeDouble(pos_op - TP * symb_point,symb_digits);
         }
      }
      //Необходимые данные для модификации позиции
      reqwest.position = position;
      reqwest.magic = pos_mag;
      reqwest.symbol = pos_symb;
      
      //Не забудьте указать требуемую операцию)
      reqwest.action = TRADE_ACTION_SLTP;
      
      //Отправка запроса на сервер. При неудаче повторям запрос при помощи цикла    
      for(int i = 0;i < 10;i++)
      {
         if(!OrderSend(reqwest,result))
         {
            Print("Позиция №",position," не была модифицирована. Ошибка№",result.retcode);
            Sleep(500);
         }
         //Если модификация позиции состоялась
         //функция возвращает Тру и завершает свою работу
         else return true;
      }
   }
   else Print("Позиция №",position," не найдена.");
   
   //Если результат выполнения функции не приводит к модификации позиции
   //функция возвращает Фэлс.
   return false;
}
bool Position_TRlSL_Modofy(ulong position, int step){
   if(PositionSelectByTicket(position))
   {
      MqlTradeRequest reqwest;
      MqlTradeResult result;
   
      ZeroMemory(reqwest);
      ZeroMemory(result);
      //Считываем необходимые свойства позиции
      double pos_oppen = PositionGetDouble(POSITION_PRICE_OPEN);
      double pos_cur = PositionGetDouble(POSITION_PRICE_CURRENT);
      string pos_symb = PositionGetString(POSITION_SYMBOL);
      ulong pos_mag = PositionGetInteger(POSITION_MAGIC);
      double pos_tp= PositionGetDouble(POSITION_TP);  
      double pos_sl= PositionGetDouble(POSITION_SL);
      //Считываем напрвление позиции
      //Все типы позиций объявлены в терминале в виде перечисления ENUM_POSITION_TYPE
      //Если это значение присваивается отдельной переменной, его обязательно нужно привести к типу перечисления ENUM_POSITION_TYPE
      ENUM_POSITION_TYPE pos_type = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
      
      //Считываем свойства торгового инструмента для дальнейих вычислений и проверок ограничения Frezze Level
      int symb_digits = (int)SymbolInfoInteger(pos_symb,SYMBOL_DIGITS);
      double symb_point = SymbolInfoDouble(pos_symb,SYMBOL_POINT);
      //int freez_level = (int)SymbolInfoInteger(pos_symb,SYMBOL_TRADE_FREEZE_LEVEL);
      if(pos_type == POSITION_TYPE_BUY)
      {
          reqwest.sl = NormalizeDouble(pos_sl + step * symb_point, symb_digits);
          reqwest.tp = pos_tp; //NormalizeDouble(pos_tp + step * symb_point, symb_digits);
      }
      else
      {
          reqwest.sl = NormalizeDouble(pos_sl - step * symb_point, symb_digits);
          reqwest.tp = pos_tp; //NormalizeDouble(pos_tp - step * symb_point, symb_digits);
      }   
      
          //Необходимые данные для модификации позиции
      reqwest.position = position;
      reqwest.magic = pos_mag;
      reqwest.symbol = pos_symb;
      
      //Не забудьте указать требуемую операцию)
      reqwest.action = TRADE_ACTION_SLTP;
      
      //Отправка запроса на сервер. При неудаче повторям запрос при помощи цикла    
      for(int i = 0;i < 10;i++)
      {
         if(!OrderSend(reqwest,result))
         {
            Print("Позиция №",position," не была модифицирована. Ошибка№",result.retcode);
            Sleep(500);
         }
         //Если модификация позиции состоялась
         //функция возвращает Тру и завершает свою работу
         else return true;
      }
   }
   else Print("Позиция №",position," не найдена.");
   
   //Если результат выполнения функции не приводит к модификации позиции
   //функция возвращает Фэлс.
   return false;

}

bool Position_SLBU_Modofy(ulong position){
   //Проверка на наличие открытой позиции с указанным идентификатором
    
   if(PositionSelectByTicket(position))
   {
      MqlTradeRequest reqwest;
      MqlTradeResult result;
   
      ZeroMemory(reqwest);
      ZeroMemory(result);
      //Считываем необходимые свойства позиции
      //ENUM_POSITION_TYPE pos_type = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
      double pos_oppen = PositionGetDouble(POSITION_PRICE_OPEN);
      double pos_cur = PositionGetDouble(POSITION_PRICE_CURRENT);
      string pos_symb = PositionGetString(POSITION_SYMBOL);
      ulong pos_mag = PositionGetInteger(POSITION_MAGIC);
      double pos_tp= PositionGetDouble(POSITION_TP);  
      double pos_sl= PositionGetDouble(POSITION_SL);
      //Считываем напрвление позиции
      //Все типы позиций объявлены в терминале в виде перечисления ENUM_POSITION_TYPE
      //Если это значение присваивается отдельной переменной, его обязательно нужно привести к типу перечисления ENUM_POSITION_TYPE
     // ENUM_POSITION_TYPE pos_type = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
      
      //Считываем свойства торгового инструмента для дальнейих вычислений и проверок ограничения Frezze Level
      int symb_digits = (int)SymbolInfoInteger(pos_symb,SYMBOL_DIGITS);
     // double symb_point = SymbolInfoDouble(pos_symb,SYMBOL_POINT);
      //int freez_level = (int)SymbolInfoInteger(pos_symb,SYMBOL_TRADE_FREEZE_LEVEL);
      
     
      reqwest.sl = NormalizeDouble(pos_oppen,symb_digits);
      reqwest.tp = NormalizeDouble(pos_tp,symb_digits);
      //Необходимые данные для модификации позиции
      reqwest.position = position;
      reqwest.magic = pos_mag;
      reqwest.symbol = pos_symb;
      
      //Не забудьте указать требуемую операцию)
      reqwest.action = TRADE_ACTION_SLTP;
      
      //Отправка запроса на сервер. При неудаче повторям запрос при помощи цикла    
      for(int i = 0;i < 10;i++)
      {
         if(!OrderSend(reqwest,result))
         {
            Print("Позиция №",position," не была модифицирована. Ошибка№",result.retcode);
            Sleep(500);
         }
         //Если модификация позиции состоялась
         //функция возвращает Тру и завершает свою работу
         else return true;
      }
   }
   else Print("Позиция №",position," не найдена.");
   
   //Если результат выполнения функции не приводит к модификации позиции
   //функция возвращает Фэлс.
   return false;
}

bool Position_TPBU_add_Modofy(ulong position,int add){
   //Проверка на наличие открытой позиции с указанным идентификатором
    
   if(PositionSelectByTicket(position))
   {
      MqlTradeRequest reqwest;
      MqlTradeResult result;
   
      ZeroMemory(reqwest);
      ZeroMemory(result);
      //Считываем необходимые свойства позиции
      ENUM_POSITION_TYPE pos_type = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
      double pos_oppen = PositionGetDouble(POSITION_PRICE_OPEN);
      double pos_cur = PositionGetDouble(POSITION_PRICE_CURRENT);
      string pos_symb = PositionGetString(POSITION_SYMBOL);
      ulong pos_mag = PositionGetInteger(POSITION_MAGIC);
      double pos_tp= PositionGetDouble(POSITION_TP);  
      double pos_sl= PositionGetDouble(POSITION_SL);
      //Считываем напрвление позиции
      //Все типы позиций объявлены в терминале в виде перечисления ENUM_POSITION_TYPE
      //Если это значение присваивается отдельной переменной, его обязательно нужно привести к типу перечисления ENUM_POSITION_TYPE
     // ENUM_POSITION_TYPE pos_type = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
      
      //Считываем свойства торгового инструмента для дальнейих вычислений и проверок ограничения Frezze Level
      int symb_digits = (int)SymbolInfoInteger(pos_symb,SYMBOL_DIGITS);
      double symb_point = SymbolInfoDouble(pos_symb,SYMBOL_POINT);
      //int freez_level = (int)SymbolInfoInteger(pos_symb,SYMBOL_TRADE_FREEZE_LEVEL);
      
      if(pos_type == POSITION_TYPE_BUY){
         
         reqwest.tp = NormalizeDouble(pos_oppen + add*symb_point,symb_digits);
         }
      else{ 
         
         reqwest.tp = NormalizeDouble(pos_oppen - add*symb_point,symb_digits);
         }
      reqwest.sl = NormalizeDouble(pos_sl,symb_digits);   
      
      //Необходимые данные для модификации позиции
      reqwest.position = position;
      reqwest.magic = pos_mag;
      reqwest.symbol = pos_symb;
      
      //Не забудьте указать требуемую операцию)
      reqwest.action = TRADE_ACTION_SLTP;
      
      //Отправка запроса на сервер. При неудаче повторям запрос при помощи цикла    
      for(int i = 0;i < 10;i++)
      {
         if(!OrderSend(reqwest,result))
         {
            Print("Позиция №",position," не была модифицирована. Ошибка№",result.retcode);
            Sleep(500);
         }
         //Если модификация позиции состоялась
         //функция возвращает Тру и завершает свою работу
         else return true;
      }
   }
   else Print("Позиция №",position," не найдена.");
   
   //Если результат выполнения функции не приводит к модификации позиции
   //функция возвращает Фэлс.
   return false;
}

bool Position_SLBU_add_Modofy(ulong position,int add){
   //Проверка на наличие открытой позиции с указанным идентификатором
    
   if(PositionSelectByTicket(position))
   {
      MqlTradeRequest reqwest;
      MqlTradeResult result;
   
      ZeroMemory(reqwest);
      ZeroMemory(result);
      //Считываем необходимые свойства позиции
         ENUM_DEAL_TYPE pos_type = 0;// (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
         char pos_typechr = 0;
         datetime pos_op_time = 0;
         double pos_op_price = 0;
        // double pos_oppen =0;
         double pos_sl = 0, pos_tp = 0;
         
           // double pos_price_cur = PositionGetDouble(POSITION_PRICE_CURRENT);
            //      double pos_cur = PositionGetDouble(POSITION_PRICE_CURRENT);
            string pos_symb = PositionGetString(POSITION_SYMBOL);
            ulong pos_mag = PositionGetInteger(POSITION_MAGIC);
      
      
      
      
      
       //PositionGetDouble(POSITION_PRICE_OPEN);
      
      //string pos_symb = PositionGetString(POSITION_SYMBOL);
      //ulong pos_mag = PositionGetInteger(POSITION_MAGIC);
      //double pos_tp= PositionGetDouble(POSITION_TP);  
     // double pos_sl= PositionGetDouble(POSITION_SL);
      //Считываем напрвление позиции
      //Все типы позиций объявлены в терминале в виде перечисления ENUM_POSITION_TYPE
      //Если это значение присваивается отдельной переменной, его обязательно нужно привести к типу перечисления ENUM_POSITION_TYPE
     // ENUM_POSITION_TYPE pos_type = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
      
           if(StringCompare(PositionGetString(POSITION_COMMENT),"[variation margin open]") == 0){
               if(HistorySelectByPosition(PositionGetInteger(POSITION_IDENTIFIER))){
                   uint     total=HistoryDealsTotal(); 
                   
                   for(uint i=0;i<total;i++) 
                   { 
                      ulong ticket = HistoryDealGetTicket(i);
                      //--- получим тикет сделки по его позиции в списке 
                      long mgk = 0;
                      if(ticket>0){
                           //if(HistoryDealGetInteger(ticket,DEAL_MAGIC,mgk)){
                              if(HistoryDealGetInteger(ticket,DEAL_ENTRY) == DEAL_ENTRY_IN){
                              
                                pos_type = (ENUM_DEAL_TYPE)HistoryDealGetInteger(ticket,DEAL_TYPE);
                                 if(pos_type == DEAL_TYPE_BUY) 
                                   { pos_typechr = 1;}
                                  else if(pos_type == DEAL_TYPE_SELL)
                                   { pos_typechr = -1;}
                                 pos_op_time = (datetime)HistoryDealGetInteger(ticket,DEAL_TIME); 
                                 pos_op_price = HistoryDealGetDouble(ticket,DEAL_PRICE);
                                 pos_sl = HistoryDealGetDouble(ticket,DEAL_SL);
                                 pos_tp = HistoryDealGetDouble(ticket,DEAL_TP);
                                 break;
                              }
                          //}
                      }
                   } 
                   
               }
            }
            if(!pos_typechr)
            {
               //Считываем необходимые свойства позиции
               pos_type = (ENUM_DEAL_TYPE)PositionGetInteger(POSITION_TYPE);
               pos_op_price = PositionGetDouble(POSITION_PRICE_OPEN);
               pos_tp= PositionGetDouble(POSITION_TP);  
               pos_sl= PositionGetDouble(POSITION_SL);
            }
      
      
      
      //Считываем свойства торгового инструмента для дальнейих вычислений и проверок ограничения Frezze Level
      int symb_digits = (int)SymbolInfoInteger(pos_symb,SYMBOL_DIGITS);
      double symb_point = SymbolInfoDouble(pos_symb,SYMBOL_POINT);
      //int freez_level = (int)SymbolInfoInteger(pos_symb,SYMBOL_TRADE_FREEZE_LEVEL);
      
      if(pos_type == DEAL_TYPE_BUY){
         reqwest.sl = NormalizeDouble(pos_op_price + add*symb_point,symb_digits);
         }
      else{ 
         reqwest.sl = NormalizeDouble(pos_op_price - add*symb_point,symb_digits);   
         }
      reqwest.tp = NormalizeDouble(pos_tp,symb_digits);
      //Необходимые данные для модификации позиции
      reqwest.position = position;
      reqwest.magic = pos_mag;
      reqwest.symbol = pos_symb;
      
      //Не забудьте указать требуемую операцию)
      reqwest.action = TRADE_ACTION_SLTP;
      
      //Отправка запроса на сервер. При неудаче повторям запрос при помощи цикла    
      for(int i = 0;i < 10;i++)
      {
         if(!OrderSend(reqwest,result))
         {
            Print("Позиция №",position," не была модифицирована. Ошибка№",result.retcode);
            Sleep(500);
         }
         //Если модификация позиции состоялась
         //функция возвращает Тру и завершает свою работу
         else return true;
      }
   }
   else Print("Позиция №",position," не найдена.");
   
   //Если результат выполнения функции не приводит к модификации позиции
   //функция возвращает Фэлс.
   return false;
}

bool Position_SLTP_Modofy(ulong position,double SL ,double TP){
        //Проверка на наличие открытой позиции с указанным идентификатором
   if(PositionSelectByTicket(position))
   {
         ENUM_DEAL_TYPE pos_type = 0;
         
         //ulong positon = 0;
         char pos_typechr = 0;
         datetime pos_op_time = 0;
         double pos_op_price = 0;
         double pos_sl = 0, pos_tp = 0;
         
            double pos_price_cur = PositionGetDouble(POSITION_PRICE_CURRENT);
            string pos_symb = PositionGetString(POSITION_SYMBOL);
            ulong pos_mag = PositionGetInteger(POSITION_MAGIC);
         
//               if(StringCompare(PositionGetString(POSITION_COMMENT),"[variation margin open]") == 0){
//               if(HistorySelectByPosition(PositionGetInteger(POSITION_IDENTIFIER))){
//                   uint     total=HistoryDealsTotal(); 
//                   
//                   for(uint i=0;i<total;i++) 
//                   { 
//                      ulong ticket = HistoryDealGetTicket(i);
//                      //--- получим тикет сделки по его позиции в списке 
//                      long mgk = 0;
//                      if(ticket>0){
//                           //if(HistoryDealGetInteger(ticket,DEAL_MAGIC,mgk)){
//                              if(HistoryDealGetInteger(ticket,DEAL_ENTRY) == DEAL_ENTRY_IN){
//                              
//                                pos_type = (ENUM_DEAL_TYPE)HistoryDealGetInteger(ticket,DEAL_TYPE);
//                                 if(pos_type == DEAL_TYPE_BUY) 
//                                   { pos_typechr = 1;}
//                                  else if(pos_type == DEAL_TYPE_SELL)
//                                   { pos_typechr = -1;}
//                                 pos_op_time = (datetime)HistoryDealGetInteger(ticket,DEAL_TIME); 
//                                 pos_op_price = HistoryDealGetDouble(ticket,DEAL_PRICE);
//                                 pos_sl = HistoryDealGetDouble(ticket,DEAL_SL);
//                                 pos_tp = HistoryDealGetDouble(ticket,DEAL_TP);
//                                 break;
//                              }
//                          //}
//                      }
//                   } 
//                   
//               }
//            }
//            if(!pos_typechr)
//            {
               //Считываем необходимые свойства позиции
               pos_type = (ENUM_DEAL_TYPE)PositionGetInteger(POSITION_TYPE);
               //double pos_price_open = PositionGetDouble(POSITION_PRICE_OPEN);
               pos_tp= PositionGetDouble(POSITION_TP);  
               pos_sl= PositionGetDouble(POSITION_SL);
        //    }

      
      
      //Считываем напрвление позиции
      //Все типы позиций объявлены в терминале в виде перечисления ENUM_POSITION_TYPE
      //Если это значение присваивается отдельной переменной, его обязательно нужно привести к типу перечисления ENUM_POSITION_TYPE
      
      
      //Считываем свойства торгового инструмента для дальнейих вычислений и проверок ограничения Frezze Level
      int symb_digits = (int)SymbolInfoInteger(pos_symb,SYMBOL_DIGITS);
      double symb_point = SymbolInfoDouble(pos_symb,SYMBOL_POINT);
      int freez_level = (int)SymbolInfoInteger(pos_symb,SYMBOL_TRADE_FREEZE_LEVEL);
      
      MqlTradeRequest reqwest;
      MqlTradeResult result;
   
      ZeroMemory(reqwest);
      ZeroMemory(result);
      if(pos_type == DEAL_TYPE_BUY){
         if(SL > 0) {
            if((pos_price_cur - SL)/symb_point < freez_level)
               reqwest.sl = NormalizeDouble(pos_price_cur - freez_level * symb_point,symb_digits);
            else
               reqwest.sl = NormalizeDouble(SL,symb_digits);
         }
         else
         {
            reqwest.sl = pos_sl;
         }   
         if(TP > 0){
            if((TP - pos_price_cur)/symb_point < freez_level)
                  reqwest.tp = NormalizeDouble(pos_price_cur + freez_level * symb_point,symb_digits);
               else
                  reqwest.tp = NormalizeDouble(TP,symb_digits);
            }
            else
            {
               reqwest.tp = pos_tp;
            }    
      }
      else{
         if(SL > 0) {
               if((SL - pos_price_cur)/symb_point < freez_level)
                  reqwest.sl = NormalizeDouble(pos_price_cur + freez_level * symb_point,symb_digits);
               else
                  reqwest.sl = NormalizeDouble(SL,symb_digits);
            }
            else
            {
               reqwest.sl = pos_sl;
            }   
            if(TP > 0){
               if((pos_price_cur - TP)/symb_point < freez_level)
                     reqwest.tp = NormalizeDouble(pos_price_cur - freez_level * symb_point,symb_digits);
                  else
                     reqwest.tp = NormalizeDouble(TP,symb_digits);
               }
               else
               {
                  reqwest.tp = pos_tp;
               }    
      
      }

        //Необходимые данные для модификации позиции
      reqwest.position = position;
      reqwest.magic = pos_mag;
      reqwest.symbol = pos_symb;
      
      //Не забудьте указать требуемую операцию)
      reqwest.action = TRADE_ACTION_SLTP;
      
      //Отправка запроса на сервер. При неудаче повторям запрос при помощи цикла    
      for(int i = 0;i < 10;i++)
      {
         if(!OrderSend(reqwest,result))
         {
            Print("Позиция №",position," не была модифицирована. Ошибка№",result.retcode,"Position_SLTP_Modofy");
            Sleep(500);
            if(result.retcode == TRADE_RETCODE_NO_CHANGES) 
               return true;
         }
         //Если модификация позиции состоялась
         //функция возвращает Тру и завершает свою работу
         else {
                Print("Позиция №",position,"была модифицирована.", result.retcode," Position_SLTP_Modofy");
               return true;
         }
      }
   }
   else Print("Позиция №",position," не найдена.");
   
   //Если результат выполнения функции не приводит к модификации позиции
   //функция возвращает Фэлс.
   return false;
}
bool Position_SLTP_Modofy(ulong position,int SL,int TP)
{
   //Проверка на наличие открытой позиции с указанным идентификатором
   if(PositionSelectByTicket(position))
   {
        ENUM_DEAL_TYPE pos_type = 0;
         
         //ulong positon = 0;
         char pos_typechr = 0;
         datetime pos_op_time = 0;
         double pos_op_price = 0;
         double pos_sl = 0, pos_tp = 0;
         
            double pos_price_cur = PositionGetDouble(POSITION_PRICE_CURRENT);
            string pos_symb = PositionGetString(POSITION_SYMBOL);
            ulong pos_mag = PositionGetInteger(POSITION_MAGIC);
         
               if(StringCompare(PositionGetString(POSITION_COMMENT),"[variation margin open]") == 0){
               if(HistorySelectByPosition(PositionGetInteger(POSITION_IDENTIFIER))){
                   uint     total=HistoryDealsTotal(); 
                   
                   for(uint i=0;i<total;i++) 
                   { 
                      ulong ticket = HistoryDealGetTicket(i);
                      //--- получим тикет сделки по его позиции в списке 
                      long mgk = 0;
                      if(ticket>0){
                           //if(HistoryDealGetInteger(ticket,DEAL_MAGIC,mgk)){
                              if(HistoryDealGetInteger(ticket,DEAL_ENTRY) == DEAL_ENTRY_IN){
                              
                                pos_type = (ENUM_DEAL_TYPE)HistoryDealGetInteger(ticket,DEAL_TYPE);
                                 if(pos_type == DEAL_TYPE_BUY) 
                                   { pos_typechr = 1;}
                                  else if(pos_type == DEAL_TYPE_SELL)
                                   { pos_typechr = -1;}
                                 pos_op_time = (datetime)HistoryDealGetInteger(ticket,DEAL_TIME); 
                                 pos_op_price = HistoryDealGetDouble(ticket,DEAL_PRICE);
                                 pos_sl = HistoryDealGetDouble(ticket,DEAL_SL);
                                 pos_tp = HistoryDealGetDouble(ticket,DEAL_TP);
                                 break;
                              }
                          //}
                      }
                   } 
                   
               }
            }
            if(!pos_typechr)
            {
      
                  
                  //Считываем необходимые свойства позиции
                   pos_op_price = PositionGetDouble(POSITION_PRICE_OPEN);
                 
            
                  pos_tp= PositionGetDouble(POSITION_TP);  
                  pos_sl= PositionGetDouble(POSITION_SL);
                  
                  //Считываем напрвление позиции
                  //Все типы позиций объявлены в терминале в виде перечисления ENUM_POSITION_TYPE
                  //Если это значение присваивается отдельной переменной, его обязательно нужно привести к типу перечисления ENUM_POSITION_TYPE
                  pos_type = (ENUM_DEAL_TYPE)PositionGetInteger(POSITION_TYPE);
            }
      //Считываем свойства торгового инструмента для дальнейих вычислений и проверок ограничения Frezze Level
      int symb_digits = (int)SymbolInfoInteger(pos_symb,SYMBOL_DIGITS);
      double symb_point = SymbolInfoDouble(pos_symb,SYMBOL_POINT);
      int freez_level = (int)SymbolInfoInteger(pos_symb,SYMBOL_TRADE_FREEZE_LEVEL);
      
      MqlTradeRequest reqwest;
      MqlTradeResult result;
   
      ZeroMemory(reqwest);
      ZeroMemory(result);
      
      if(pos_type == DEAL_TYPE_BUY)
      {
         if(SL > 0) 
         {
            //Если уровень Стоп Лосс подлежит изменению - новая его величина в пунктах не должна быть меньше ограничения Frezze Level
            if(SL < freez_level) SL = freez_level;
            
            reqwest.sl = NormalizeDouble(pos_price_cur - SL * symb_point,symb_digits);
         }
         else
            {
               reqwest.sl = pos_sl;
            }
         if(TP > 0)
         {
            //Если уровень Тейк Профит подлежит изменению - новая его величина в пунктах не должна быть меньше ограничения Frezze Level
            if(TP < freez_level) TP = freez_level;
            
            reqwest.tp = NormalizeDouble(pos_price_cur + TP * symb_point,symb_digits);
         }
         else
            {
               reqwest.tp = pos_tp;
            }
      }
      else
      {
         if(SL > 0)
         {
            if(SL < freez_level) SL = freez_level;
            reqwest.sl = NormalizeDouble(pos_price_cur + SL * symb_point,symb_digits);
         }
         else
            {
               reqwest.sl = pos_sl;
            }
         if(TP > 0)
         {
            if(TP < freez_level) TP = freez_level;
            reqwest.tp = NormalizeDouble(pos_price_cur - TP * symb_point,symb_digits);
         }
         else
            {
               reqwest.tp = pos_tp;
            }
      }
      //Необходимые данные для модификации позиции
      reqwest.position = position;
      reqwest.magic = pos_mag;
      reqwest.symbol = pos_symb;
      
      //Не забудьте указать требуемую операцию)
      reqwest.action = TRADE_ACTION_SLTP;
      
      //Отправка запроса на сервер. При неудаче повторям запрос при помощи цикла    
      for(int i = 0;i < 10;i++)
      {
         if(!OrderSend(reqwest,result))
         {
            Print("Позиция №",position," не была модифицирована. Ошибка№",result.retcode);
            Sleep(500);
         }
         //Если модификация позиции состоялась
         //функция возвращает Тру и завершает свою работу
         else return true;
      }
   }
   else Print("Позиция №",position," не найдена.");
   
   //Если результат выполнения функции не приводит к модификации позиции
   //функция возвращает Фэлс.
   return false;
}

bool GetClosedPositionProperty(ulong posID, int& type, double& open_price, double& close_price, double& startSL){
      HistorySelectByPosition(posID);
      
      int pos_total = HistoryDealsTotal();
      
      for(int i = 0; i<pos_total; i++){
           ulong  cur_deal_tiket = HistoryDealGetTicket(i);
           if (HistoryDealGetInteger(cur_deal_tiket,DEAL_ENTRY) == DEAL_ENTRY_IN){
               open_price = HistoryDealGetDouble(cur_deal_tiket,DEAL_PRICE);
               
               startSL = HistoryDealGetDouble(cur_deal_tiket,DEAL_SL);
               if((int)HistoryDealGetInteger(cur_deal_tiket,DEAL_TYPE) == DEAL_TYPE_BUY)
                    type = 1;
               if((int)HistoryDealGetInteger(cur_deal_tiket,DEAL_TYPE) == DEAL_TYPE_SELL)
                      type = -1;
               //(int)HistoryDealGetInteger(cur_deal_tiket,DEAL_TICKET);
           }
           if (HistoryDealGetInteger(cur_deal_tiket,DEAL_ENTRY) == DEAL_ENTRY_OUT){
               close_price = HistoryDealGetDouble(cur_deal_tiket,DEAL_PRICE);
           } 
      
      }
      if((open_price > 0) && (close_price > 0)) 
            return true;
      else return false;

      
}
//+------------------------------------------------------------------+
//Функция для подсчета кол-ва позиций робота на конкретном торговом инструменте
//Переменная magic отвечает за идентификацию позиции, как открытой этим роботом
//Переменная symbol указывает инструмент, на котором производится поиск позиций робота
int CountPositions(int magic , string symbol)
{
   //Переменная-счетчик позиций. Изначально считаем, что позиций нашего робота нет
   int count = 0;                                                          
   
   //Перебираем все имеющиеся на торговом счете позиции
   for(int i = 0;i < PositionsTotal();i++)
   {
      //Вытаскиваем тикет позиции с индексом i и сохраняем его
      //в переменной pos
      ulong pos = PositionGetTicket(i);
      
      //Если позиция с таким тикетом есть и её данные загружены в память
      if(PositionSelectByTicket(pos))
      {
         //Соответствующими функциями считываем нужные свойства позиции
         //и сохраняем их значения соответствующие переменные
         ulong pos_mag = PositionGetInteger(POSITION_MAGIC);
         string pos_symb = PositionGetString(POSITION_SYMBOL);
         
         //Если свойства позиции совпадают с контрольными значениями
         //увеличиваем значение переменной-счетчика на один
         if(pos_mag == magic && pos_symb == symbol) count++;
      }
   }
   
   //Функция позвращает итоговый результат в виде
   //итогового значения переменной-счетчика
   return count;
}
//+------------------------------------------------------------------+
//Перечисления для возможных вариантов направления искомой позиции
//Можно использовать в самых разных функциях, где подобное уместно
//Главное - оъявить перечисления ДО оъявления нужных функций
/*enum Direction {
                  direction_buy, 
                  direction_sell 
               };*/
//+------------------------------------------------------------------+
//Вариант перегрузки функции CountPositions с учетом
//направления искомых позиций
//За направление отвечает переменная direction
//которая имеет тип перечисления Direction, оъявленного шагом ранее
int CountPositions(int magic , string symbol , bool direction_is_buy)
{
   int count = 0;
   
   
   //Отдельная переменная для контроля направления позиции
   //При присвоении значения переменной type явное приведение типов оязательно
   //во избежание ошибок
   ENUM_POSITION_TYPE type;
   if(direction_is_buy) type = (ENUM_POSITION_TYPE)POSITION_TYPE_BUY;
   else type = (ENUM_POSITION_TYPE)POSITION_TYPE_SELL;
   
   for(int i = 0;i < PositionsTotal();i++)
   {
      ulong pos = PositionGetTicket(i);
      if(PositionSelectByTicket(pos))
      {
         ulong pos_mag = PositionGetInteger(POSITION_MAGIC);
         string pos_symb = PositionGetString(POSITION_SYMBOL);
         
         //Считываем направление выбранной позиции. Тоже с явным приведением типов
         ENUM_POSITION_TYPE pos_type = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
         
         if(pos_mag == magic && pos_symb == symbol && pos_type == type) count++;
      }
   }
   
   return count;
}
//+------------------------------------------------------------------+
//Вариант перегрузки функции CountPositions без учета торгового инструмента
//Считает все позиции, открытые указанным роботом на тоговом счете
//Дабы не делать лишней работы, просто закомментированы неиспользуемые элементы
int CountPositions(int magic /*, string symbol*/)
{
   int count = 0;
   
   for(int i = 0;i < PositionsTotal();i++)
   {
      ulong pos = PositionGetTicket(i);
      if(PositionSelectByTicket(pos))
      {
         ulong pos_mag = PositionGetInteger(POSITION_MAGIC);
         //string pos_symb = PositionGetString(POSITION_SYMBOL);
         
         if(pos_mag == magic /*&& pos_symb == symbol*/) count++;
      }
   }
   
   return count;
}
//+------------------------------------------------------------------+
//Вариант перегрузки функции CountPositions без учета принадлежности к роботам
//Считает все позиции, открытые на указанном тоговом инструменте
//Дабы не делать лишней работы, просто закомментированы неиспользуемые элементы
int CountPositions(/*int magic ,*/ string symbol)
{
   int count = 0;
   
   for(int i = 0;i < PositionsTotal();i++)
   {
      ulong pos = PositionGetTicket(i);
      if(PositionSelectByTicket(pos))
      {
         //ulong pos_mag = PositionGetInteger(POSITION_MAGIC);
         string pos_symb = PositionGetString(POSITION_SYMBOL);
         
         if(/*pos_mag == magic &&*/ pos_symb == symbol) count++;
      }
   }
   
   return count;
}
//+------------------------------------------------------------------+
//Функция возвращает расстояние в пунктах между ценовыми уровнями priceA и priceB
//Параметр symbol соощает имя торгового инструмента, по ценам которого осуществляется рассчет
int PriceDistanceUnsigned(double priceA , double priceB , string symbol)
{
   return (int)(MathAbs(priceA - priceB) / SymbolInfoDouble(symbol,SYMBOL_POINT));
}
int PriceDistanceSigned(double priceA , double priceB , string symbol)
{
   return (int)((priceA - priceB) / SymbolInfoDouble(symbol,SYMBOL_POINT));
}
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//
//int ProfitPipMax(ulong position ){
//     if(PositionSelectByTicket(position)){
//       
//      Считываем необходимые свойства позиции
//      string pos_symb = PositionGetString(POSITION_SYMBOL);
//      ulong pos_mag = PositionGetInteger(POSITION_MAGIC);
//      
//      double pos_op_price = PositionGetDouble(POSITION_PRICE_OPEN);
//      double pos_cur_price = PositionGetDouble(POSITION_PRICE_CURRENT);
//      double pos_delta_price = pos_cur_price - pos_op_price;
//      
//
//      
//      Считываем напрвление позиции
//      Все типы позиций объявлены в терминале в виде перечисления ENUM_POSITION_TYPE
//      Если это значение присваивается отдельной переменной, его обязательно нужно привести к типу перечисления ENUM_POSITION_TYPE
//      ENUM_POSITION_TYPE pos_type = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
//      
//      Считываем свойства торгового инструмента для дальнейих вычислений и проверок ограничения Frezze Level
//      int symb_digits = (int)SymbolInfoInteger(pos_symb,SYMBOL_DIGITS);
//      double symb_point = SymbolInfoDouble(pos_symb,SYMBOL_POINT);
//      int freez_level = (int)SymbolInfoInteger(pos_symb,SYMBOL_TRADE_FREEZE_LEVEL);
//      
// 
//      
//      if(pos_type == POSITION_TYPE_BUY)
//      {
//          return (int)((iHigh(pos_symb,PERIOD_M1,1) - pos_op_price)/symb_point);
//         
//      }
//      else
//      {
//           return (int)((pos_op_price - iLow(pos_symb,PERIOD_M1,1))/symb_point);
//        
//      }
//
//      
//  
//   }  
//         
//    return 0;     
//     
//     
//      
//}
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//Функция считает приыль по открытой позиции

//Параметр position отвечает за тикет позиции, приыль которой считаем

//Параметр out_comission задает комиссию за один стандартный лот сдлеки. Служит для корректного подсчета комисси при закрытии позиции
//если равен нулю - или комиссии нет, или она не взымается с закрывающих сделок

//Параметр subtotals отвечает за подсчет изменения баланса торгового счета, с учетом изменений, происходивших с позицией. При значении
//TRUE считаем, при значении FALSE - не считаем
//double Profit(ulong position, double out_comission, bool subtotals)
//{
//   //Переменная под общее значение прибыли позиции
//   double total_profit = 0;
//   
//   //Переменные под значения прибыли, свопа и комиссии для позиции в рынке
//   double profit = 0, swap = 0, comission = 0;
//   
//   //Переменная под объем рыночной позиции. Нужна для корректного подсчета комиссии при закрытии позиции
//   double volume = 0;
//   
//   //Считываем нужные свойства позиции иприсваиваем их значения соответствующим переменным
//   if(PositionSelectByTicket(position))
//   {
//      profit = PositionGetDouble(POSITION_PROFIT);
//      swap = PositionGetDouble(POSITION_SWAP);
//      volume = PositionGetDouble(POSITION_VOLUME);
//   }
//   
//   //Проходимся по всем сделкам, которые как-то влияли на позицию
//   //В том числе, считаем комисси по этим сделкам
//   //Соответствующие значения увеличиваем нарастающим итогом
//   if(HistorySelectByPosition(position))
//   {
//      for(int i = 0;i < HistoryDealsTotal();i++)
//      {
//         ulong deal = HistoryDealGetTicket(i);
//         
//         //Если промежуточные итоги работы комиссии на неттинговом счете нужны,
//         //соответствующие переменные участвуют в расчетах
//         if(subtotals)
//         {
//            profit += HistoryDealGetDouble(deal,DEAL_PROFIT);
//            swap += HistoryDealGetDouble(deal,DEAL_SWAP);
//         }
//         comission += HistoryDealGetDouble(deal,DEAL_COMMISSION);
//      }
//   }
//   
//   //Окончательный подсчет прибыли
//   total_profit = (profit + swap + comission) - out_comission * volume;
//   
//   return NormalizeDouble(total_profit,2);
//}





//+---------------------------------------------------------------+
//Функция закытия позиции с рынка
//position указывает на позицию, которую требуется закрыть
//slipage допустимое проскальзывание от текущей рыночной котировки в пунктах
bool Close_Position(ulong position, int slipage)
{
   //Проверка на наличие указанной позиции на торговом счете
   if(PositionSelectByTicket(position))                                                      
   {
      //Получам нужные далее значения свойств закрываемой позиции
      string pos_symb = PositionGetString(POSITION_SYMBOL);                                  //Имя торгового инструмента, на котором открыта позиция
      ulong pos_mag = PositionGetInteger(POSITION_MAGIC);                                    //Идентификатор робота, открывшего позицию
      double pos_volume = PositionGetDouble(POSITION_VOLUME);                                //Объем позиции
      
      ENUM_POSITION_TYPE pos_type = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);   //Направление позиции
      
      //Формируем торговый приказ
      MqlTradeRequest reqwest;
      MqlTradeResult result;
   
      ZeroMemory(reqwest);
      ZeroMemory(result);
      
      if(pos_type == POSITION_TYPE_BUY)                              //Если закрываеая позиция на Покупку
      {
         reqwest.price = SymbolInfoDouble(pos_symb,SYMBOL_BID);      //Она должа закрываться по цене Бид
         reqwest.type = ORDER_TYPE_SELL;                             //Операциией, противоположной направлению открытой позиции
      }
      else
      {
         reqwest.price = SymbolInfoDouble(pos_symb,SYMBOL_ASK);
         reqwest.type = ORDER_TYPE_BUY;
      }
      
      //Поля, обязательные для операции закрытия позиции, не зависящи от её напрвления
      reqwest.position = position;
      reqwest.magic = pos_mag;
      reqwest.symbol = pos_symb;
      reqwest.volume = pos_volume;
      reqwest.deviation = slipage;
      reqwest.action = TRADE_ACTION_DEAL;
      
      //Отправка торгового запроса на сервер сконтролем результата   
      for(int i = 0;i < 10;i++)
      {
         if(!OrderSend(reqwest,result))
         {
            Print("Позиция №",position," не была закрыта. Ошибка№",result.retcode);
            Sleep(500);
         }
         else return true;
      }
   }
   else Print("Позиция №",position," не найдена.");
   
   return false;
}





bool CloseAllPositionsBySymb(/*int magic ,*/ string symbol)
{
   int count = 0;
   
   for(int i = 0;i < PositionsTotal();i++)
   {
      ulong pos = PositionGetTicket(i);
      if(PositionSelectByTicket(pos))
      {
         //ulong pos_mag = PositionGetInteger(POSITION_MAGIC);
         string pos_symb = PositionGetString(POSITION_SYMBOL);
         
         if( pos_symb == symbol) {
             if(!Close_Position(pos,10)) return false;
         }
      }
   }
   
   return true;
}
//+------------------------------------------------------------------+

bool CancelAllPendingOrderBySymb(string symbol, ulong Magic_nu){

      MqlTradeRequest request;
      MqlTradeResult result;
      
      int total=OrdersTotal(); // количество установленных отложенных ордеров
      //--- перебор всех установленных отложенных ордеров
      for(int i=total-1; i>=0; i--)
      {
            ulong  order_ticket = OrderGetTicket(i);
              
            ulong  magic = OrderGetInteger(ORDER_MAGIC);               // MagicNumber ордера
            string order_symb = OrderGetString(ORDER_SYMBOL);            
            //--- если MagicNumber совпадает
            if((magic == Magic_nu) && (order_symb == symbol))
              {
               //--- обнуление значений запроса и результата
               ZeroMemory(request);
               ZeroMemory(result);
               //--- установка параметров операции     
               request.action=   TRADE_ACTION_REMOVE;                   // тип торговой операции
               request.order = order_ticket;                         // тикет ордера
               //--- отправка запроса
               if(!OrderSend(request,result))
               {
                  PrintFormat("OrderSend error %d",GetLastError());  // если отправить запрос не удалось, вывести код ошибки
                  return false;
               }
               //--- информация об операции   
               PrintFormat("retcode=%u  deal=%I64u  order=%I64u",result.retcode,result.deal,result.order);
              }
      }
      
      return true;
      
      
}

int OrderTotalBySymb(string symbol){

      int cnt = 0;
      int total=OrdersTotal(); // количество установленных отложенных ордеров
      //--- перебор всех установленных отложенных ордеров
      for(int i=total-1; i>=0; i--)
      {
            ulong  order_ticket = OrderGetTicket(i);
              
            //ulong  magic = OrderGetInteger(ORDER_MAGIC);               // MagicNumber ордера
            string order_symb = OrderGetString(ORDER_SYMBOL);            
            //--- если MagicNumber совпадает
            if(/*(magic == Magic_num) && */(order_symb == symbol))
            cnt++;
              
      }
      
      return cnt;
      
      
}

int OrderTotalBySymb(string symbol, ulong Magic_nu){

      int cnt = 0;
      int total=OrdersTotal(); // количество установленных отложенных ордеров
      //--- перебор всех установленных отложенных ордеров
      for(int i=total-1; i>=0; i--)
      {
            ulong  order_ticket = OrderGetTicket(i);
              
            ulong  magic = OrderGetInteger(ORDER_MAGIC);               // MagicNumber ордера
            string order_symb = OrderGetString(ORDER_SYMBOL);            
            //--- если MagicNumber совпадает
            if((magic == Magic_nu) && (order_symb == symbol))
            cnt++;
              
      }
      
      return cnt;
      
      
}

//bool AddLVLs_toStr(double cpHl, double cpLl, datetime time){
//
//for(int i = 0; i< TradeLVLsize; i++){
//
//
//}
//
//
//return true;
//
//}
//bool AddLVLaver_toStr(double CurPeriod_Aver_lvl, double LVL_width,datetime t_d){
//
//for(int i = 0; i< TradeLVLsize; i++){
//
//
//}
//
//
//return true;
//}

//trdlvl & operator = (trdlvl& tr1, trdlvl& tr2){
//tr1.formtime 
//}
