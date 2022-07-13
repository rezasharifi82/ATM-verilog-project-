//In The Name Of God
//Sharifi Mohammadreza 
//4001262557
//Finally compiled at 03:43 AM !
// Run Without any bug!

module get_data(givena,sai,founded);

    input [15:0] givena;
    
    output [3:0] sai;
    reg [3:0] sai,index;
    output founded;
    reg founded,ow;
    
    reg [15:0] Accounts [0:14];

    initial begin
    Accounts[0] = 1456; 
    Accounts[1] = 2175; 
    Accounts[2] = 4532; 
    Accounts[3] = 2125; 
    Accounts[4] = 2178;
    Accounts[5] = 2647; 
    Accounts[6] = 1234; 
    Accounts[7] = 1478; 
    Accounts[8] = 6658; 
    Accounts[9] = 4125;
    Accounts[10] = 6125; 
    Accounts[11] = 4111; 
    Accounts[12] = 3425; 
    Accounts[13] = 4135; 
    Accounts[14] = 4115;  
    end


  integer i;
  always @(givena) begin
      sai = 4'b0000;
      index=0;
      ow=0;

      //finding loop
      for(i = 0; i < 15; i = i+1) begin
            $display("for loop iterative index : %d",i);
            $display("given account number : %d",givena);
          if(givena == Accounts[i]) begin
                ow=1'b1;
                index = i;
                $display("Oh! it's founded at : %d",index);


          end    
      end
      sai=index;
      founded=ow;
    $display("finally founded at : %d",sai);
    $display("is founded? : %d",founded);
  end
    
endmodule


module ATM(clk,given_account_number,destination_account_number,Entered_opt,amount, error,balance);
  input clk;
  input [15:0] given_account_number; //the account number that user entered
  input [15:0] destination_account_number; //Obvious :)
  input [1:0]Entered_opt;// change the current state to preferred one
  input [9:0] amount; // used to check validity of money transfering or withdrawing
  output reg error; //if error happend
  output reg [9:0] balance; //to save or show ballance
  reg [1:0] instate = 2'b00; //machine has several state this variable can define the current runnig state
  reg [9:0] Balance [0:14];
  wire [3:0] myaccount_Index;
  wire [3:0] destination_Index;
  wire ifound; //check 1 if the given account number is valid 
  wire dfound; //check 1 if destination account num is valid.
  

    //First done
  initial begin
     Balance[0] = 400;
     Balance[1] = 544;
     Balance[2] = 250;
     Balance[3] = 110;
     Balance[4] = 50;
     Balance[5] = 120;
     Balance[6] = 180;
     Balance[7] = 780;
     Balance[8] = 110;
     Balance[9] = 910;
     Balance[10] = 555;
     Balance[11] = 222;
     Balance[12] = 111;
     Balance[13] = 452;
     Balance[14] = 234;
  end
  
  

  get_data check_myaccount(given_account_number, myaccount_Index,ifound);
  get_data check_desaccount(destination_account_number, destination_Index,dfound);

  
  always @(posedge clk or ifound or Entered_opt) begin
    
	error = 1'b0;
    
    if(instate == 2'b00) begin
      instate=Entered_opt;
      $display("instate:   %d ",instate);
    end
    

    if(instate==2'b01) begin
        $display("Balancing Action");
        $display("Current 0:  %d",Balance[0]);
        $display("Current 1:  %d",Balance[1]);
        $display("Current 2:  %d",Balance[2]);
        $display("Current 3:  %d",Balance[3]);
        $display("Current 4:  %d",Balance[4]);
        $display("Current 5:  %d",Balance[5]);
        $display("Current 6:  %d",Balance[6]);
        $display("Current 7:  %d",Balance[7]);
        $display("Current 8:  %d",Balance[8]);

        balance=Balance[myaccount_Index];
        $display("Given account index:  %d",myaccount_Index);
        $display("So in that account you have: %d",balance);

    end
      

    if(instate==2'b10) begin
        if(amount<=Balance[myaccount_Index]) begin
            $display("Withdrawing Action");
            $display("needed money:  %d",amount);
            $display("from account number:  %d",myaccount_Index);
            $display("which has enough money :  %d",Balance[myaccount_Index]);
        Balance[myaccount_Index]=Balance[myaccount_Index]-amount;
        $display("after withdrawing you have:  %d",Balance[myaccount_Index]);
        end
        else begin
            error=1;
            $display("Hey Bro! unfortunately not enough money! :(");
            instate=2'b00;
            end

    end

    if(instate==2'b11) begin
        if ((amount<=Balance[myaccount_Index])) begin
            if (dfound==1) begin
                if (Balance[myaccount_Index]+Balance[destination_Index]<1023) begin
                    $display("Transfering Action");
                    $display("amount of money:  %d",amount);
                    $display("from account number :  %d",myaccount_Index);
                    $display("which has :  %d",Balance[myaccount_Index]);
                    $display("to account number :  %d",destination_Index);
                    $display("which has  %d",Balance[destination_Index]);
                    $display("current account number 1 balance:  %d",given_account_number);
                    $display("Current account No.2 balance :   %d",destination_account_number);
                    Balance[destination_Index]=Balance[destination_Index]+amount;
                    Balance[myaccount_Index]=Balance[myaccount_Index]-amount;
                    error=0;
                    instate=2'b00;
                end else begin
                    $display("too much money! overflow :|");
                    error=1;
                    instate=2'b00;
                end
            end else begin
                $display("You gonna transfer money to GOD gracias!");
                error=1;
                instate=2'b00;
            end
            
        end
        else begin
            $display("Sorry Bro!,not enough money");
            error=1;
            instate=2'b00;
        end
    end
    end

endmodule