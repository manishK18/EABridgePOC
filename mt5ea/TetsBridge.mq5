#property strict

int sock = INVALID_HANDLE;

int OnInit()
{
   sock = SocketCreate();
   if(sock == INVALID_HANDLE)
   {
      Print("SOCKET CREATE FAILED");
      return INIT_FAILED;
   }

   if(!SocketConnect(sock, "127.0.0.1", 5555, 5000))
   {
      Print("CONNECT FAILED: ", GetLastError());
      return INIT_FAILED;
   }

   Print("CONNECTED");
   return INIT_SUCCEEDED;
}

void OnTick()
{
   MqlTick tick;

   if(!SymbolInfoTick(_Symbol, tick))
      return;

   string msg = StringFormat(
      "%s|%.2f|%.2f|%I64d\n",
      _Symbol,
      tick.bid,
      tick.ask,
      tick.time
   );

   uchar data[];
   StringToCharArray(msg, data);
   int sent = SocketSend(sock, data, ArraySize(data));
   if(sent <= 0)
   {
      Print("SEND FAILED: ", GetLastError());
   }
}

void OnDeinit(const int reason)
{
   if(sock != INVALID_HANDLE)
      SocketClose(sock);
}