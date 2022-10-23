#include <bits/stdc++.h>
using namespace std;

vector<string> wordseperator(string str);

//Defining the mapping functions i'll be using - 
//(i) FOR R-TYPE INSTRUCTIONS
unordered_map<string,string> regDefine();

//(ii) FOR I-TYPE INSTRUCTIONS
unordered_map<string,string> immDefine();

//(iii) FOR J-TYPE INSTRUCTIONS
unordered_map<string,string> jumDefine();

//Mapping function for MIPS registers.
unordered_map<string,int> registers();

string regTrans(string str, int lineNum, unordered_map<string,int> &registerlist);


bool is_number(const string &s);
string bin_to_hex(string str);
string tobin26(string str);
string tobin16(string str);
string tobin5(string str);
long tolong(string str);
string tohex(string str);

void invalidInstruction(int lineNum);


int main(){
    string infilename;
    string outfilename;
    bool littleEndian;
    bool hex;
    bool writeZeros;
    int lineNum = 0;
    long memSize = 32768;

    unordered_map<string,string> registerMap = regDefine();
    unordered_map<string,string> immediateMap = immDefine();
    unordered_map<string,string> jumpMap = jumDefine();
    unordered_map<string,int> registerlist = registers();

    infilename = "assembly_code.txt";
    ifstream inputfile(infilename);             // Comes from the fstream library. ifstream is a class, of which, inputfile is an input filestream object, with the name 'infilename'.

    if(inputfile.is_open()){
        string outfilename = "PARSED_"+infilename;
        ofstream outputfile(outfilename);


        //Assembling instructions
        string instr;
        while(getline(inputfile,instr)){
            if(instr == "end:"){
                break;
            }
            lineNum++;
            string binTrans;
            replace(instr.begin(), instr.end(), '(', ' ');             
            replace(instr.begin(), instr.end(), ')', ' ');
            string temp = instr.substr(0, instr.find("#", 0));
            vector<string> line = wordseperator(temp);


            // (i) For REGISTER-TYPE INSTRUCTIONS ( R-TYPE )
            if(registerMap.find(line[0])!=registerMap.end()) {
                binTrans = "000000";
                if(line[0] == "jr") {
                    if (line.size()!=2) {
                        invalidInstruction(lineNum);
                    }
                    binTrans = binTrans + regTrans(line[1],lineNum, registerlist)+ bitset<15>(0).to_string() + registerMap.at(line[0]);
                }

                else if(line[0] == "mfhi" ||line[0] == "mflo") {
                    if (line.size()!=2) {
                        invalidInstruction(lineNum);
                    }
                    binTrans = binTrans + bitset<10>(0).to_string()+ regTrans(line[1],lineNum, registerlist)+ bitset<5>(0).to_string() + registerMap.at(line[0]);
                }
                else if(line[0] == "jalr") {
                    if (!(line.size() ==3||line.size() ==2)) {
                    invalidInstruction(lineNum);
                    }
                    if(line.size() == 3) {
                        binTrans = binTrans + regTrans(line[2],lineNum, registerlist) + bitset<5>(0).to_string() + regTrans(line[1],lineNum, registerlist)+ bitset<5>(0).to_string() + registerMap.at(line[0]);
                    }

                    else if(line.size() == 2) {
                        binTrans = binTrans + regTrans(line[1],lineNum, registerlist) + bitset<5>(0).to_string()+"11111"+bitset<5>(0).to_string() + registerMap.at(line[0]);
                    }
                }

                else if (line[0] == "mul" ||line[0] == "mulu" || line[0] == "div" ||line[0] == "divu") {
                    if (line.size()!=3) {
                        invalidInstruction(lineNum);
                    }
                    binTrans = binTrans + regTrans(line[1],lineNum, registerlist) + regTrans(line[2],lineNum, registerlist) + bitset<10>(0).to_string()+registerMap.at(line[0]);
                }

                else if(line[0] == "sll") {
                    if (line.size()!=4) {
                        invalidInstruction(lineNum);
                    }
                    binTrans = binTrans + bitset<5>(0).to_string() + regTrans(line[1],lineNum, registerlist) + regTrans(line[2],lineNum, registerlist) + tobin5(line[3])+ registerMap.at(line[0]);
                }
                else {
                    if (line.size()!=4) {
                        invalidInstruction(lineNum);
                    }
                    binTrans = binTrans + regTrans(line[2],lineNum, registerlist) + regTrans(line[3],lineNum, registerlist)+ regTrans(line[1],lineNum, registerlist) + bitset<5>(0).to_string() + registerMap.at(line[0]);
                }
                outputfile << binTrans;
                outputfile << endl;
            }

            // (ii) FOR IMMEDIATE-TYPE INSTRUCTIONS  ( I-TYPE )
            else if(immediateMap.find(line[0]) != immediateMap.end()) {
                if(line[0] == "lui") {
                    if (line.size()!=3) {
                        invalidInstruction(lineNum);
                    }
                    binTrans = immediateMap.at(line[0]) + "00000" + regTrans(line[1],lineNum, registerlist) + tobin16(line[2]);
                }
                else if (line[0] == "bltz" || line[0] == "blez" || line[0] == "bgtz") {
                    if (line.size()!=3) {
                        invalidInstruction(lineNum);
                    }
                    binTrans = immediateMap.at(line[0]) + regTrans(line[1],lineNum, registerlist) + "00000" + tobin16(line[2]);
                }
                else if (line[0] == "bgez") {
                    if (line.size()!=3) {
                        invalidInstruction(lineNum);
                    }
                    binTrans = immediateMap.at(line[0]) + regTrans(line[1],lineNum, registerlist) + "00001" + tobin16(line[2]);
                }
                else if (line[0] == "bltzal") {
                    if (line.size()!=3){invalidInstruction(lineNum);}
                    binTrans = immediateMap.at(line[0]) + regTrans(line[1],lineNum, registerlist) + "10000" + tobin16(line[2]);
                }else if(line[0] == "bgezal"){
                    if (line.size()!=3){invalidInstruction(lineNum);}
                    binTrans = immediateMap.at(line[0]) + regTrans(line[1],lineNum, registerlist) + "10001" + tobin16(line[2]);
                }else if(line[0] == "bne" || line[0] == "beq"){
                    if (line.size()!=4){invalidInstruction(lineNum);}
                    binTrans = immediateMap.at(line[0]) + regTrans(line[1],lineNum, registerlist) + regTrans(line[2],lineNum, registerlist) + tobin16(line[3]);
                } else if (line[0] == "addiu" || line[0] == "addi" || line[0] == "andi" ||line[0] == "ori" ||line[0] == "slti"||line[0] == "sltiu"){
                    if (line.size()!=4){invalidInstruction(lineNum);}
                    binTrans = immediateMap.at(line[0]) + regTrans(line[2],lineNum, registerlist) + regTrans(line[1],lineNum, registerlist) + tobin16(line[3]);
                } else{
                    if (line.size()!=4){invalidInstruction(lineNum);}
                    binTrans = immediateMap.at(line[0]) + regTrans(line[3],lineNum, registerlist) + regTrans(line[1],lineNum, registerlist) + tobin16(line[2]);
                }
                outputfile << binTrans <<endl;
            }

            // For JUMP INSTRUCTIONS ( J-TYPE )
            else if(jumpMap.find(line[0]) != jumpMap.end()) {
                if(line[0] == "j") {
                    if (line.size()!=2){invalidInstruction(lineNum);}
                    binTrans = jumpMap.at(line[0]) + tobin26(line[1]);
                } 
                else if (line[0] == "jal") {
                    if (line.size()!=2) {
                        invalidInstruction(lineNum);
                    }
                    binTrans = jumpMap.at(line[0]) + tobin26(line[1]);
                }
                outputfile << binTrans << endl;
            }

            // To take care of other cases.
            else {
                invalidInstruction(lineNum);
                exit(EXIT_FAILURE);
            }

            string hexTrans = bin_to_hex(binTrans.substr(0,8))+" "+bin_to_hex(binTrans.substr(8,8))+" "+bin_to_hex(binTrans.substr(16,8))+" "+bin_to_hex(binTrans.substr(24,8));
            string littleEndianTrans = hexTrans.substr(9,2)+" "+hexTrans.substr(6,2)+" "+hexTrans.substr(3,2)+" "+hexTrans.substr(0,2);
        }
    } 

    else {
        cerr <<"Unable to open file";
        exit(EXIT_FAILURE);
    }
    exit(EXIT_SUCCESS);

}

string tobin26(string str){
    if(str.substr(0,2) == "0x") {
        return bitset<26>(stol(str.substr(2),nullptr,16)).to_string();
    }
    else if(is_number(str)) {
        return bitset<26>(stol(str, nullptr, 10)).to_string();
    }
    else {
    cerr<< "Value is not hex or dec!";
    exit(EXIT_FAILURE);
    }
}


string tobin16(string str){
    if(str.substr(0,2) == "0x") {
        return bitset<16>(stol(str.substr(2),nullptr,16)).to_string();
    }
    else if(is_number(str)) {
        return bitset<16>(stol(str, nullptr, 10)).to_string();
    }
    else {
    cerr<< "Value is not hex or dec!";
    exit(EXIT_FAILURE);
    }
}


string tobin5(string str){
    if(str.substr(0,2) == "0x") {
        return bitset<5>(stol(str.substr(2),nullptr,16)).to_string();
    }
    else if(is_number(str)) {
        return bitset<5>(stol(str, nullptr, 10)).to_string();
    }
    else { 
    cerr<< "Value is not hex or dec!";
    exit(EXIT_FAILURE);
    }
}


long tolong(string str){
    if(str.substr(0,2) == "0x"){
        return stol(str.substr(2),nullptr,16);
    }else if(is_number(str)){
        return stol(str);
    }else{cerr<< "Value is not hex or dec!";exit(EXIT_FAILURE);}
}


string tohex(string str){
    if(str.substr(0,2) == "0x"){
        return str.substr(2);
    }else if(is_number(str)){
        stringstream ss;
        ss<< hex << setfill('0') << setw(2) << stol(str);
        return (ss.str());
    }else{cerr<< "Value is not hex or dec!";exit(EXIT_FAILURE);}
}


//The following function will split the string of bits around spaces
vector<string> wordseperator(string str) {

    transform(str.begin(), str.end(), str.begin(), ::tolower);
    // stringstream allows us to interpret a string as a stream; and we can read it 
    stringstream ss(str);

    istream_iterator<string> begin(ss);
    istream_iterator<std::string> end;
    vector<string> vstrings(begin, end);
    //copy(vstrings.begin(), vstrings.end(), ostream_iterator<string>(std::cerr, "\n"));
    return vstrings;
}

// This function notifies whenever an invalid instruction is encountered.
void invalidInstruction(int lineNum){
    cerr << "Invalid Instruction at line " << lineNum << endl;
    exit(EXIT_FAILURE);
}

string regTrans(string str, int lineNum, unordered_map<string,int> &registerlist){
    int reg;
    if(registerlist.find(str) != registerlist.end()){
        return bitset<5>(registerlist.at(str)).to_string();
    }else if (str[0] != '$'){
        cerr << "Register " << str << " at line "<< lineNum << " is invalid" <<endl;
        exit(EXIT_FAILURE);
    } else {
        str.erase(str.begin());
        reg = stoi(str);
        if(reg > 31){
            cerr << "Register " << str << " at line "<< lineNum << " is invalid" <<endl;
            exit(EXIT_FAILURE);
        } else {
            return bitset<5>(reg).to_string();
        }
    }
}

string bin_to_hex(string str){
    bitset<8> set(str);
    stringstream res;
    res << hex << uppercase <<setfill('0')<<setw(2)<< set.to_ullong();
    return res.str();
}

unordered_map<string,string> regDefine(){
    unordered_map<string, string> umap;
    umap["add"] = "100000";
    umap["addu"] = "100001";
    umap["and"]  = "100100";
    umap["break"] = "001101";
    umap["div"] = "011010";
    umap["divu"] = "011011";
    umap["jalr"] = "001001";
    umap["jr"] = "001000";
    umap["mfhi"] = "010000";
    umap["mflo"] = "010010";
    umap["mul"] = "011000";
    umap["mulu"]= "011001";
    umap["nor"] = "100111";
    umap["or"] = "100101";
    umap["sll"]  = "000000";
    umap["sllv"] = "000100";
    umap["slt"]  = "101010";
    umap["sltu"] = "101011";
    umap["sub"] = "100010";
    umap["subu"] = "100011";
    umap["syscall"] = "001100";
    umap["xor"]  = "100110";

    return umap;
}

unordered_map<string,int> registers(){
    unordered_map<string, int> umap;
    umap["r0"] = 0;
    umap["r1"] = 1;
    umap["r2"] = 2;
    umap["r3"] = 3;
    umap["r4"] = 4;
    umap["r5"] = 5;
    umap["r6"] = 6;
    umap["r7"] = 7;
    umap["r8"] = 8;
    umap["r9"] = 9;
    umap["r10"] = 10;
    umap["r11"] = 11;
    umap["r12"] = 12;
    umap["r13"] = 13;
    umap["r14"] = 14;
    umap["r15"] = 15;
    umap["r16"] = 16;
    umap["r17"] = 17;
    umap["r18"] = 18;
    umap["r19"] = 19;
    umap["r20"] = 20;
    umap["r21"] = 21;
    umap["r22"] = 22;
    umap["r23"] = 23;
    umap["r24"] = 24;
    umap["r25"] = 25;
    umap["r26"] = 26;
    umap["r27"] = 27;
    umap["r28"] = 28;
    umap["r29"] = 29;
    umap["r30"] = 30;
    umap["r31"] = 31;
    return umap;
}

unordered_map<string,string> immDefine(){
    unordered_map<string, string> umap;
    umap["addi"] = "001000";
    umap["addiu"] = "001001";
    umap["andi"] = "001100";
    umap["beq"] = "000100";
    umap["bgez"] = "000001";
    umap["bgtz"] = "000111";
    umap["blez"] = "000110";
    umap["bltz"] = "000001";
    umap["bne"] = "000101";
    umap["lb"] = "100000";
    umap["lbu"] = "100100";
    umap["lh"] = "100001";
    umap["lhu"] = "100101";
    umap["lui"] = "001111";
    umap["lw"] = "100011";
    umap["lwl"] = "100010";
    umap["lwr"] = "100110";
    umap["ori"] = "001101";
    umap["sb"] = "101000";
    umap["slti"]  = "001010";
    umap["sltiu"] = "001011";
    umap["sh"] = "101001";
    umap["sw"] = "101011";
    umap["swcl"] = "111001";

    return umap;
}

unordered_map<string,string> jumDefine(){
    unordered_map<string, string> umap;

    umap["j"] = "000010";
    umap["jal"] = "000011";

    return umap;
}

bool is_number(const string& s)
{
    for (int i = 0; i < s.length(); i++)
        if (isdigit(s[i]) == false)
            return false;

    return true;
}