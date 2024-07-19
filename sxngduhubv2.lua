--[[
 .____                  ________ ___.    _____                           __                
 |    |    __ _______   \_____  \\_ |___/ ____\_ __  ______ ____ _____ _/  |_  ___________ 
 |    |   |  |  \__  \   /   |   \| __ \   __\  |  \/  ___// ___\\__  \\   __\/  _ \_  __ \
 |    |___|  |  // __ \_/    |    \ \_\ \  | |  |  /\___ \\  \___ / __ \|  | (  <_> )  | \/
 |_______ \____/(____  /\_______  /___  /__| |____//____  >\___  >____  /__|  \____/|__|   
         \/          \/         \/    \/                \/     \/     \/                   
          \_Welcome to LuaObfuscator.com   (Alpha 0.10.6) ~  Much Love, Ferib 

]]--

local StrToNumber = tonumber;
local Byte = string.byte;
local Char = string.char;
local Sub = string.sub;
local Subg = string.gsub;
local Rep = string.rep;
local Concat = table.concat;
local Insert = table.insert;
local LDExp = math.ldexp;
local GetFEnv = getfenv or function()
	return _ENV;
end;
local Setmetatable = setmetatable;
local PCall = pcall;
local Select = select;
local Unpack = unpack or table.unpack;
local ToNumber = tonumber;
local function VMCall(ByteString, vmenv, ...)
	local DIP = 1;
	local repeatNext;
	ByteString = Subg(Sub(ByteString, 5), "..", function(byte)
		if (Byte(byte, 2) == 79) then
			repeatNext = StrToNumber(Sub(byte, 1, 1));
			return "";
		else
			local FlatIdent_12703 = 0;
			local a;
			while true do
				if (FlatIdent_12703 == 0) then
					a = Char(StrToNumber(byte, 16));
					if repeatNext then
						local b = Rep(a, repeatNext);
						repeatNext = nil;
						return b;
					else
						return a;
					end
					break;
				end
			end
		end
	end);
	local function gBit(Bit, Start, End)
		if End then
			local Res = (Bit / (2 ^ (Start - 1))) % (2 ^ (((End - 1) - (Start - 1)) + 1));
			return Res - (Res % 1);
		else
			local Plc = 2 ^ (Start - 1);
			return (((Bit % (Plc + Plc)) >= Plc) and 1) or 0;
		end
	end
	local function gBits8()
		local a = Byte(ByteString, DIP, DIP);
		DIP = DIP + 1;
		return a;
	end
	local function gBits16()
		local a, b = Byte(ByteString, DIP, DIP + 2);
		DIP = DIP + 2;
		return (b * 256) + a;
	end
	local function gBits32()
		local FlatIdent_2BD95 = 0;
		local a;
		local b;
		local c;
		local d;
		while true do
			if (FlatIdent_2BD95 == 1) then
				return (d * 16777216) + (c * 65536) + (b * 256) + a;
			end
			if (FlatIdent_2BD95 == 0) then
				a, b, c, d = Byte(ByteString, DIP, DIP + 3);
				DIP = DIP + 4;
				FlatIdent_2BD95 = 1;
			end
		end
	end
	local function gFloat()
		local Left = gBits32();
		local Right = gBits32();
		local IsNormal = 1;
		local Mantissa = (gBit(Right, 1, 20) * (2 ^ 32)) + Left;
		local Exponent = gBit(Right, 21, 31);
		local Sign = ((gBit(Right, 32) == 1) and -1) or 1;
		if (Exponent == 0) then
			if (Mantissa == 0) then
				return Sign * 0;
			else
				Exponent = 1;
				IsNormal = 0;
			end
		elseif (Exponent == 2047) then
			return ((Mantissa == 0) and (Sign * (1 / 0))) or (Sign * NaN);
		end
		return LDExp(Sign, Exponent - 1023) * (IsNormal + (Mantissa / (2 ^ 52)));
	end
	local function gString(Len)
		local Str;
		if not Len then
			local FlatIdent_60EA1 = 0;
			while true do
				if (FlatIdent_60EA1 == 0) then
					Len = gBits32();
					if (Len == 0) then
						return "";
					end
					break;
				end
			end
		end
		Str = Sub(ByteString, DIP, (DIP + Len) - 1);
		DIP = DIP + Len;
		local FStr = {};
		for Idx = 1, #Str do
			FStr[Idx] = Char(Byte(Sub(Str, Idx, Idx)));
		end
		return Concat(FStr);
	end
	local gInt = gBits32;
	local function _R(...)
		return {...}, Select("#", ...);
	end
	local function Deserialize()
		local Instrs = {};
		local Functions = {};
		local Lines = {};
		local Chunk = {Instrs,Functions,nil,Lines};
		local ConstCount = gBits32();
		local Consts = {};
		for Idx = 1, ConstCount do
			local Type = gBits8();
			local Cons;
			if (Type == 1) then
				Cons = gBits8() ~= 0;
			elseif (Type == 2) then
				Cons = gFloat();
			elseif (Type == 3) then
				Cons = gString();
			end
			Consts[Idx] = Cons;
		end
		Chunk[3] = gBits8();
		for Idx = 1, gBits32() do
			local Descriptor = gBits8();
			if (gBit(Descriptor, 1, 1) == 0) then
				local Type = gBit(Descriptor, 2, 3);
				local Mask = gBit(Descriptor, 4, 6);
				local Inst = {gBits16(),gBits16(),nil,nil};
				if (Type == 0) then
					Inst[3] = gBits16();
					Inst[4] = gBits16();
				elseif (Type == 1) then
					Inst[3] = gBits32();
				elseif (Type == 2) then
					Inst[3] = gBits32() - (2 ^ 16);
				elseif (Type == 3) then
					local FlatIdent_31A5A = 0;
					while true do
						if (FlatIdent_31A5A == 0) then
							Inst[3] = gBits32() - (2 ^ 16);
							Inst[4] = gBits16();
							break;
						end
					end
				end
				if (gBit(Mask, 1, 1) == 1) then
					Inst[2] = Consts[Inst[2]];
				end
				if (gBit(Mask, 2, 2) == 1) then
					Inst[3] = Consts[Inst[3]];
				end
				if (gBit(Mask, 3, 3) == 1) then
					Inst[4] = Consts[Inst[4]];
				end
				Instrs[Idx] = Inst;
			end
		end
		for Idx = 1, gBits32() do
			Functions[Idx - 1] = Deserialize();
		end
		return Chunk;
	end
	local function Wrap(Chunk, Upvalues, Env)
		local Instr = Chunk[1];
		local Proto = Chunk[2];
		local Params = Chunk[3];
		return function(...)
			local Instr = Instr;
			local Proto = Proto;
			local Params = Params;
			local _R = _R;
			local VIP = 1;
			local Top = -1;
			local Vararg = {};
			local Args = {...};
			local PCount = Select("#", ...) - 1;
			local Lupvals = {};
			local Stk = {};
			for Idx = 0, PCount do
				if (Idx >= Params) then
					Vararg[Idx - Params] = Args[Idx + 1];
				else
					Stk[Idx] = Args[Idx + 1];
				end
			end
			local Varargsz = (PCount - Params) + 1;
			local Inst;
			local Enum;
			while true do
				local FlatIdent_61585 = 0;
				while true do
					if (1 == FlatIdent_61585) then
						if (Enum <= 30) then
							if (Enum <= 14) then
								if (Enum <= 6) then
									if (Enum <= 2) then
										if (Enum <= 0) then
											if Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										elseif (Enum > 1) then
											local FlatIdent_1BCFB = 0;
											local A;
											local K;
											local B;
											while true do
												if (FlatIdent_1BCFB == 0) then
													A = nil;
													K = nil;
													B = nil;
													Stk[Inst[2]] = Inst[3];
													FlatIdent_1BCFB = 1;
												end
												if (3 == FlatIdent_1BCFB) then
													Stk[Inst[2]] = K;
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													FlatIdent_1BCFB = 4;
												end
												if (FlatIdent_1BCFB == 2) then
													Inst = Instr[VIP];
													B = Inst[3];
													K = Stk[B];
													for Idx = B + 1, Inst[4] do
														K = K .. Stk[Idx];
													end
													FlatIdent_1BCFB = 3;
												end
												if (FlatIdent_1BCFB == 4) then
													Stk[A](Stk[A + 1]);
													VIP = VIP + 1;
													Inst = Instr[VIP];
													VIP = Inst[3];
													break;
												end
												if (1 == FlatIdent_1BCFB) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													FlatIdent_1BCFB = 2;
												end
											end
										else
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										end
									elseif (Enum <= 4) then
										if (Enum == 3) then
											local FlatIdent_99389 = 0;
											local A;
											while true do
												if (FlatIdent_99389 == 0) then
													A = Inst[2];
													Stk[A](Stk[A + 1]);
													break;
												end
											end
										else
											local A;
											local K;
											local B;
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											B = Inst[3];
											K = Stk[B];
											for Idx = B + 1, Inst[4] do
												K = K .. Stk[Idx];
											end
											Stk[Inst[2]] = K;
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
										end
									elseif (Enum == 5) then
										Stk[Inst[2]]();
									else
										local Edx;
										local Results, Limit;
										local B;
										local A;
										Stk[Inst[2]] = Env[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
										Top = (Limit + A) - 1;
										Edx = 0;
										for Idx = A, Top do
											local FlatIdent_8CEDF = 0;
											while true do
												if (FlatIdent_8CEDF == 0) then
													Edx = Edx + 1;
													Stk[Idx] = Results[Edx];
													break;
												end
											end
										end
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]]();
										VIP = VIP + 1;
										Inst = Instr[VIP];
										VIP = Inst[3];
									end
								elseif (Enum <= 10) then
									if (Enum <= 8) then
										if (Enum == 7) then
											local NewProto = Proto[Inst[3]];
											local NewUvals;
											local Indexes = {};
											NewUvals = Setmetatable({}, {__index=function(_, Key)
												local Val = Indexes[Key];
												return Val[1][Val[2]];
											end,__newindex=function(_, Key, Value)
												local Val = Indexes[Key];
												Val[1][Val[2]] = Value;
											end});
											for Idx = 1, Inst[4] do
												VIP = VIP + 1;
												local Mvm = Instr[VIP];
												if (Mvm[1] == 19) then
													Indexes[Idx - 1] = {Stk,Mvm[3]};
												else
													Indexes[Idx - 1] = {Upvalues,Mvm[3]};
												end
												Lupvals[#Lupvals + 1] = Indexes;
											end
											Stk[Inst[2]] = Wrap(NewProto, NewUvals, Env);
										else
											local FlatIdent_33EA4 = 0;
											local Step;
											local Index;
											local A;
											while true do
												if (FlatIdent_33EA4 == 5) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													FlatIdent_33EA4 = 6;
												end
												if (FlatIdent_33EA4 == 0) then
													Step = nil;
													Index = nil;
													A = nil;
													FlatIdent_33EA4 = 1;
												end
												if (FlatIdent_33EA4 == 4) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													FlatIdent_33EA4 = 5;
												end
												if (FlatIdent_33EA4 == 3) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													FlatIdent_33EA4 = 4;
												end
												if (FlatIdent_33EA4 == 2) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													FlatIdent_33EA4 = 3;
												end
												if (FlatIdent_33EA4 == 1) then
													A = Inst[2];
													Stk[A] = Stk[A](Stk[A + 1]);
													VIP = VIP + 1;
													FlatIdent_33EA4 = 2;
												end
												if (FlatIdent_33EA4 == 6) then
													Inst = Instr[VIP];
													A = Inst[2];
													Index = Stk[A];
													FlatIdent_33EA4 = 7;
												end
												if (FlatIdent_33EA4 == 7) then
													Step = Stk[A + 2];
													if (Step > 0) then
														if (Index > Stk[A + 1]) then
															VIP = Inst[3];
														else
															Stk[A + 3] = Index;
														end
													elseif (Index < Stk[A + 1]) then
														VIP = Inst[3];
													else
														Stk[A + 3] = Index;
													end
													break;
												end
											end
										end
									elseif (Enum > 9) then
										local FlatIdent_52551 = 0;
										local A;
										while true do
											if (FlatIdent_52551 == 0) then
												A = Inst[2];
												Stk[A] = Stk[A]();
												break;
											end
										end
									else
										local Edx;
										local Results, Limit;
										local B;
										local A;
										Stk[Inst[2]] = Env[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
										Top = (Limit + A) - 1;
										Edx = 0;
										for Idx = A, Top do
											local FlatIdent_287B5 = 0;
											while true do
												if (FlatIdent_287B5 == 0) then
													Edx = Edx + 1;
													Stk[Idx] = Results[Edx];
													break;
												end
											end
										end
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A]();
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Inst[4];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										VIP = Inst[3];
									end
								elseif (Enum <= 12) then
									if (Enum == 11) then
										VIP = Inst[3];
									else
										local A = Inst[2];
										local Index = Stk[A];
										local Step = Stk[A + 2];
										if (Step > 0) then
											if (Index > Stk[A + 1]) then
												VIP = Inst[3];
											else
												Stk[A + 3] = Index;
											end
										elseif (Index < Stk[A + 1]) then
											VIP = Inst[3];
										else
											Stk[A + 3] = Index;
										end
									end
								elseif (Enum > 13) then
									local A = Inst[2];
									local Cls = {};
									for Idx = 1, #Lupvals do
										local List = Lupvals[Idx];
										for Idz = 0, #List do
											local Upv = List[Idz];
											local NStk = Upv[1];
											local DIP = Upv[2];
											if ((NStk == Stk) and (DIP >= A)) then
												local FlatIdent_4CC24 = 0;
												while true do
													if (FlatIdent_4CC24 == 0) then
														Cls[DIP] = NStk[DIP];
														Upv[1] = Cls;
														break;
													end
												end
											end
										end
									end
								else
									local FlatIdent_207CC = 0;
									local Edx;
									local Results;
									local Limit;
									local B;
									local A;
									while true do
										if (FlatIdent_207CC == 4) then
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]]();
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_207CC = 5;
										end
										if (FlatIdent_207CC == 0) then
											Edx = nil;
											Results, Limit = nil;
											B = nil;
											A = nil;
											Stk[Inst[2]] = Env[Inst[3]];
											VIP = VIP + 1;
											FlatIdent_207CC = 1;
										end
										if (2 == FlatIdent_207CC) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
											FlatIdent_207CC = 3;
										end
										if (FlatIdent_207CC == 5) then
											VIP = Inst[3];
											break;
										end
										if (FlatIdent_207CC == 3) then
											Top = (Limit + A) - 1;
											Edx = 0;
											for Idx = A, Top do
												local FlatIdent_7F121 = 0;
												while true do
													if (FlatIdent_7F121 == 0) then
														Edx = Edx + 1;
														Stk[Idx] = Results[Edx];
														break;
													end
												end
											end
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											FlatIdent_207CC = 4;
										end
										if (FlatIdent_207CC == 1) then
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											FlatIdent_207CC = 2;
										end
									end
								end
							elseif (Enum <= 22) then
								if (Enum <= 18) then
									if (Enum <= 16) then
										if (Enum == 15) then
											local B;
											local A;
											A = Inst[2];
											Stk[A] = Stk[A](Stk[A + 1]);
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
										else
											local Edx;
											local Results, Limit;
											local B;
											local A;
											Stk[Inst[2]] = Env[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
											Top = (Limit + A) - 1;
											Edx = 0;
											for Idx = A, Top do
												Edx = Edx + 1;
												Stk[Idx] = Results[Edx];
											end
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]]();
											VIP = VIP + 1;
											Inst = Instr[VIP];
											VIP = Inst[3];
										end
									elseif (Enum > 17) then
										local B;
										local A;
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3] ~= 0;
									else
										Stk[Inst[2]] = Inst[3] ~= 0;
									end
								elseif (Enum <= 20) then
									if (Enum > 19) then
										if (Stk[Inst[2]] == Inst[4]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									else
										Stk[Inst[2]] = Stk[Inst[3]];
									end
								elseif (Enum == 21) then
									local FlatIdent_206F8 = 0;
									local B;
									local A;
									while true do
										if (FlatIdent_206F8 == 0) then
											B = nil;
											A = nil;
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											FlatIdent_206F8 = 1;
										end
										if (FlatIdent_206F8 == 1) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											FlatIdent_206F8 = 2;
										end
										if (4 == FlatIdent_206F8) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3] ~= 0;
											break;
										end
										if (FlatIdent_206F8 == 3) then
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_206F8 = 4;
										end
										if (FlatIdent_206F8 == 2) then
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											FlatIdent_206F8 = 3;
										end
									end
								else
									local B;
									local A;
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
								end
							elseif (Enum <= 26) then
								if (Enum <= 24) then
									if (Enum > 23) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3] ~= 0;
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Inst[4];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Inst[4];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Inst[4];
									else
										Stk[Inst[2]] = Upvalues[Inst[3]];
									end
								elseif (Enum == 25) then
									Stk[Inst[2]] = Env[Inst[3]];
								else
									local B;
									local A;
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3] ~= 0;
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3] ~= 0;
								end
							elseif (Enum <= 28) then
								if (Enum == 27) then
									Stk[Inst[2]][Inst[3]] = Inst[4];
								else
									local FlatIdent_2BE02 = 0;
									local A;
									local T;
									local B;
									while true do
										if (FlatIdent_2BE02 == 1) then
											B = Inst[3];
											for Idx = 1, B do
												T[Idx] = Stk[A + Idx];
											end
											break;
										end
										if (FlatIdent_2BE02 == 0) then
											A = Inst[2];
											T = Stk[A];
											FlatIdent_2BE02 = 1;
										end
									end
								end
							elseif (Enum == 29) then
								local FlatIdent_3CF01 = 0;
								local A;
								local K;
								local B;
								while true do
									if (FlatIdent_3CF01 == 0) then
										A = nil;
										K = nil;
										B = nil;
										Stk[Inst[2]] = Inst[3];
										FlatIdent_3CF01 = 1;
									end
									if (FlatIdent_3CF01 == 4) then
										Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										VIP = Inst[3];
										break;
									end
									if (FlatIdent_3CF01 == 3) then
										Stk[Inst[2]] = K;
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										FlatIdent_3CF01 = 4;
									end
									if (FlatIdent_3CF01 == 2) then
										Inst = Instr[VIP];
										B = Inst[3];
										K = Stk[B];
										for Idx = B + 1, Inst[4] do
											K = K .. Stk[Idx];
										end
										FlatIdent_3CF01 = 3;
									end
									if (FlatIdent_3CF01 == 1) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										FlatIdent_3CF01 = 2;
									end
								end
							else
								local B;
								local A;
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								VIP = Inst[3];
							end
						elseif (Enum <= 46) then
							if (Enum <= 38) then
								if (Enum <= 34) then
									if (Enum <= 32) then
										if (Enum == 31) then
											local FlatIdent_4508F = 0;
											local A;
											local Results;
											local Limit;
											local Edx;
											while true do
												if (FlatIdent_4508F == 2) then
													for Idx = A, Top do
														Edx = Edx + 1;
														Stk[Idx] = Results[Edx];
													end
													break;
												end
												if (FlatIdent_4508F == 1) then
													Top = (Limit + A) - 1;
													Edx = 0;
													FlatIdent_4508F = 2;
												end
												if (FlatIdent_4508F == 0) then
													A = Inst[2];
													Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
													FlatIdent_4508F = 1;
												end
											end
										else
											local FlatIdent_5431F = 0;
											local A;
											local T;
											while true do
												if (FlatIdent_5431F == 0) then
													A = Inst[2];
													T = Stk[A];
													FlatIdent_5431F = 1;
												end
												if (FlatIdent_5431F == 1) then
													for Idx = A + 1, Inst[3] do
														Insert(T, Stk[Idx]);
													end
													break;
												end
											end
										end
									elseif (Enum == 33) then
										local FlatIdent_86900 = 0;
										local A;
										while true do
											if (FlatIdent_86900 == 0) then
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
												break;
											end
										end
									else
										local K;
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										B = Inst[3];
										K = Stk[B];
										for Idx = B + 1, Inst[4] do
											K = K .. Stk[Idx];
										end
										Stk[Inst[2]] = K;
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										VIP = Inst[3];
									end
								elseif (Enum <= 36) then
									if (Enum == 35) then
										local Edx;
										local Results, Limit;
										local B;
										local A;
										Stk[Inst[2]] = Env[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
										Top = (Limit + A) - 1;
										Edx = 0;
										for Idx = A, Top do
											Edx = Edx + 1;
											Stk[Idx] = Results[Edx];
										end
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]]();
										VIP = VIP + 1;
										Inst = Instr[VIP];
										VIP = Inst[3];
									else
										local FlatIdent_81225 = 0;
										while true do
											if (FlatIdent_81225 == 5) then
												Stk[Inst[2]] = Inst[3] ~= 0;
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_81225 = 6;
											end
											if (6 == FlatIdent_81225) then
												Stk[Inst[2]] = Inst[3] ~= 0;
												break;
											end
											if (FlatIdent_81225 == 3) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_81225 = 4;
											end
											if (FlatIdent_81225 == 4) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_81225 = 5;
											end
											if (FlatIdent_81225 == 1) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_81225 = 2;
											end
											if (FlatIdent_81225 == 0) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_81225 = 1;
											end
											if (FlatIdent_81225 == 2) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_81225 = 3;
											end
										end
									end
								elseif (Enum > 37) then
									Stk[Inst[2]] = {};
								else
									do
										return;
									end
								end
							elseif (Enum <= 42) then
								if (Enum <= 40) then
									if (Enum > 39) then
										local B;
										local A;
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3] ~= 0;
									else
										local A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
									end
								elseif (Enum > 41) then
									local FlatIdent_6D68E = 0;
									local Edx;
									local Results;
									local Limit;
									local B;
									local A;
									while true do
										if (FlatIdent_6D68E == 3) then
											Inst = Instr[VIP];
											A = Inst[2];
											Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
											Top = (Limit + A) - 1;
											Edx = 0;
											FlatIdent_6D68E = 4;
										end
										if (FlatIdent_6D68E == 1) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											FlatIdent_6D68E = 2;
										end
										if (FlatIdent_6D68E == 4) then
											for Idx = A, Top do
												Edx = Edx + 1;
												Stk[Idx] = Results[Edx];
											end
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
											FlatIdent_6D68E = 5;
										end
										if (FlatIdent_6D68E == 6) then
											VIP = Inst[3];
											break;
										end
										if (2 == FlatIdent_6D68E) then
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											FlatIdent_6D68E = 3;
										end
										if (FlatIdent_6D68E == 5) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]]();
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_6D68E = 6;
										end
										if (FlatIdent_6D68E == 0) then
											Edx = nil;
											Results, Limit = nil;
											B = nil;
											A = nil;
											Stk[Inst[2]] = Env[Inst[3]];
											FlatIdent_6D68E = 1;
										end
									end
								else
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								end
							elseif (Enum <= 44) then
								if (Enum == 43) then
									local B;
									local A;
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Env[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
								else
									local FlatIdent_3B08E = 0;
									local A;
									while true do
										if (FlatIdent_3B08E == 4) then
											Inst = Instr[VIP];
											VIP = Inst[3];
											break;
										end
										if (FlatIdent_3B08E == 0) then
											A = nil;
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_3B08E = 1;
										end
										if (FlatIdent_3B08E == 1) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_3B08E = 2;
										end
										if (3 == FlatIdent_3B08E) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											FlatIdent_3B08E = 4;
										end
										if (FlatIdent_3B08E == 2) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											FlatIdent_3B08E = 3;
										end
									end
								end
							elseif (Enum > 45) then
								local Edx;
								local Results, Limit;
								local B;
								local A;
								Stk[Inst[2]] = Env[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
								Top = (Limit + A) - 1;
								Edx = 0;
								for Idx = A, Top do
									local FlatIdent_512FF = 0;
									while true do
										if (FlatIdent_512FF == 0) then
											Edx = Edx + 1;
											Stk[Idx] = Results[Edx];
											break;
										end
									end
								end
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]]();
								VIP = VIP + 1;
								Inst = Instr[VIP];
								VIP = Inst[3];
							else
								local FlatIdent_829F9 = 0;
								local K;
								local B;
								local A;
								while true do
									if (FlatIdent_829F9 == 4) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										B = Inst[3];
										K = Stk[B];
										FlatIdent_829F9 = 5;
									end
									if (FlatIdent_829F9 == 2) then
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_829F9 = 3;
									end
									if (FlatIdent_829F9 == 3) then
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										FlatIdent_829F9 = 4;
									end
									if (FlatIdent_829F9 == 1) then
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_829F9 = 2;
									end
									if (FlatIdent_829F9 == 0) then
										K = nil;
										B = nil;
										A = nil;
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_829F9 = 1;
									end
									if (FlatIdent_829F9 == 5) then
										for Idx = B + 1, Inst[4] do
											K = K .. Stk[Idx];
										end
										Stk[Inst[2]] = K;
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										FlatIdent_829F9 = 6;
									end
									if (6 == FlatIdent_829F9) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										break;
									end
								end
							end
						elseif (Enum <= 54) then
							if (Enum <= 50) then
								if (Enum <= 48) then
									if (Enum == 47) then
										local A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									elseif (Inst[2] == Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 49) then
									local FlatIdent_7B2D6 = 0;
									local B;
									local A;
									while true do
										if (FlatIdent_7B2D6 == 7) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											FlatIdent_7B2D6 = 8;
										end
										if (FlatIdent_7B2D6 == 4) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											FlatIdent_7B2D6 = 5;
										end
										if (FlatIdent_7B2D6 == 0) then
											B = nil;
											A = nil;
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											FlatIdent_7B2D6 = 1;
										end
										if (FlatIdent_7B2D6 == 2) then
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											FlatIdent_7B2D6 = 3;
										end
										if (FlatIdent_7B2D6 == 3) then
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_7B2D6 = 4;
										end
										if (FlatIdent_7B2D6 == 8) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											break;
										end
										if (6 == FlatIdent_7B2D6) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_7B2D6 = 7;
										end
										if (5 == FlatIdent_7B2D6) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_7B2D6 = 6;
										end
										if (FlatIdent_7B2D6 == 1) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											FlatIdent_7B2D6 = 2;
										end
									end
								else
									for Idx = Inst[2], Inst[3] do
										Stk[Idx] = nil;
									end
								end
							elseif (Enum <= 52) then
								if (Enum > 51) then
									local FlatIdent_92514 = 0;
									local Edx;
									local Results;
									local Limit;
									local B;
									local A;
									while true do
										if (6 == FlatIdent_92514) then
											VIP = Inst[3];
											break;
										end
										if (FlatIdent_92514 == 3) then
											Inst = Instr[VIP];
											A = Inst[2];
											Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
											Top = (Limit + A) - 1;
											Edx = 0;
											FlatIdent_92514 = 4;
										end
										if (FlatIdent_92514 == 2) then
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											FlatIdent_92514 = 3;
										end
										if (FlatIdent_92514 == 1) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											FlatIdent_92514 = 2;
										end
										if (FlatIdent_92514 == 0) then
											Edx = nil;
											Results, Limit = nil;
											B = nil;
											A = nil;
											Stk[Inst[2]] = Env[Inst[3]];
											FlatIdent_92514 = 1;
										end
										if (FlatIdent_92514 == 4) then
											for Idx = A, Top do
												Edx = Edx + 1;
												Stk[Idx] = Results[Edx];
											end
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
											FlatIdent_92514 = 5;
										end
										if (FlatIdent_92514 == 5) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]]();
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_92514 = 6;
										end
									end
								else
									local FlatIdent_506A5 = 0;
									local B;
									local A;
									while true do
										if (6 == FlatIdent_506A5) then
											Stk[Inst[2]] = Inst[3] ~= 0;
											break;
										end
										if (FlatIdent_506A5 == 5) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_506A5 = 6;
										end
										if (FlatIdent_506A5 == 1) then
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_506A5 = 2;
										end
										if (FlatIdent_506A5 == 4) then
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_506A5 = 5;
										end
										if (0 == FlatIdent_506A5) then
											B = nil;
											A = nil;
											A = Inst[2];
											FlatIdent_506A5 = 1;
										end
										if (FlatIdent_506A5 == 3) then
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											FlatIdent_506A5 = 4;
										end
										if (FlatIdent_506A5 == 2) then
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_506A5 = 3;
										end
									end
								end
							elseif (Enum > 53) then
								local A = Inst[2];
								local B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
							else
								local FlatIdent_1F620 = 0;
								local B;
								local A;
								while true do
									if (FlatIdent_1F620 == 0) then
										B = nil;
										A = nil;
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										FlatIdent_1F620 = 1;
									end
									if (6 == FlatIdent_1F620) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_1F620 = 7;
									end
									if (FlatIdent_1F620 == 5) then
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										FlatIdent_1F620 = 6;
									end
									if (2 == FlatIdent_1F620) then
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_1F620 = 3;
									end
									if (FlatIdent_1F620 == 4) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										FlatIdent_1F620 = 5;
									end
									if (7 == FlatIdent_1F620) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										VIP = Inst[3];
										break;
									end
									if (FlatIdent_1F620 == 1) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										FlatIdent_1F620 = 2;
									end
									if (3 == FlatIdent_1F620) then
										Stk[Inst[2]] = Env[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										FlatIdent_1F620 = 4;
									end
								end
							end
						elseif (Enum <= 58) then
							if (Enum <= 56) then
								if (Enum == 55) then
									local A = Inst[2];
									Stk[A](Unpack(Stk, A + 1, Inst[3]));
								else
									local FlatIdent_6B9E2 = 0;
									local B;
									local K;
									while true do
										if (FlatIdent_6B9E2 == 0) then
											B = Inst[3];
											K = Stk[B];
											FlatIdent_6B9E2 = 1;
										end
										if (FlatIdent_6B9E2 == 1) then
											for Idx = B + 1, Inst[4] do
												K = K .. Stk[Idx];
											end
											Stk[Inst[2]] = K;
											break;
										end
									end
								end
							elseif (Enum > 57) then
								local A = Inst[2];
								local Step = Stk[A + 2];
								local Index = Stk[A] + Step;
								Stk[A] = Index;
								if (Step > 0) then
									if (Index <= Stk[A + 1]) then
										VIP = Inst[3];
										Stk[A + 3] = Index;
									end
								elseif (Index >= Stk[A + 1]) then
									VIP = Inst[3];
									Stk[A + 3] = Index;
								end
							else
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Env[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								do
									return;
								end
							end
						elseif (Enum <= 60) then
							if (Enum == 59) then
								Stk[Inst[2]] = Inst[3];
							else
								local B = Stk[Inst[4]];
								if not B then
									VIP = VIP + 1;
								else
									local FlatIdent_1CFC3 = 0;
									while true do
										if (FlatIdent_1CFC3 == 0) then
											Stk[Inst[2]] = B;
											VIP = Inst[3];
											break;
										end
									end
								end
							end
						elseif (Enum > 61) then
							Stk[Inst[2]] = Wrap(Proto[Inst[3]], nil, Env);
						else
							local FlatIdent_45CCF = 0;
							while true do
								if (FlatIdent_45CCF == 1) then
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									FlatIdent_45CCF = 2;
								end
								if (FlatIdent_45CCF == 2) then
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_45CCF = 3;
								end
								if (FlatIdent_45CCF == 0) then
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									FlatIdent_45CCF = 1;
								end
								if (FlatIdent_45CCF == 4) then
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3] ~= 0;
									break;
								end
								if (FlatIdent_45CCF == 3) then
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3] ~= 0;
									FlatIdent_45CCF = 4;
								end
							end
						end
						VIP = VIP + 1;
						break;
					end
					if (0 == FlatIdent_61585) then
						Inst = Instr[VIP];
						Enum = Inst[1];
						FlatIdent_61585 = 1;
					end
				end
			end
		end;
	end
	return Wrap(Deserialize(), {}, vmenv)(...);
end
return VMCall("LOL!5B3O00028O00026O000840027O004003093O004E6577546F2O676C65033D3O00E0B8A5E0B987E0B8ADE0B881E0B8ABE0B8B1E0B8A720E0B980E0B89AE0B895E0B989E0B8B22F41696D626F74206265746120F09F91A4206374726C2B51026O00104003273O0020E0B881E0B8A3E0B8ADE0B89A202F20455350204652414D4520F09FA78A206374726C2B662O2003383O0020E0B980E0B8AAE0B989E0B899E0B89AE0B8B0E0B8ABE0B8A1E0B8B5E0B989202F20455350204C494E4520F09FA78A206374726C2B4C2O20026O00F03F03173O0020E0B8A7E0B8B2E0B89B202F20545020F09FA78A3O2003153O00E0B89AE0B8B4E0B899202F20466C792O20F09FA68B026O00184003063O004E6F7469667903183O004C6F6164656420424C55454E49474854206578616D706C6503073O0073752O63652O7303113O00496E69744E6F74696669636174696F6E73026O003440026O00F0BF03043O007461736B03043O0077616974029A5O99A93F032C3O004C6F6164696E6720424C55454E49474854206C69622076322C20706C656173652062652070617469656E742E030B3O00696E666F726D6174696F6E03053O007469746C65030D3O00424C55454E4947485420485542030C3O00496E74726F64756374696F6E026O001440030A3O004E657754657874626F7803123O005465787420626F782033205B6C617267655D034O0003013O00332O033O00612O6C03053O006C61726765030B3O004E657753656C6563746F72030A3O0053656C6563746F72203103063O0062756E67696503023O0066672O033O0066676503093O00412O644F7074696F6E03093O004E6577536C6964657203083O00536C69646572203103013O002F2O033O006D696E2O033O006D6178026O00594003073O0064656661756C7403213O005465787420626F782031205B6175746F207363616C6573202O2F20736D612O6C5D03013O003103053O00736D612O6C03133O005465787420626F782032205B6D656469756D5D03013O003203063O006D656469756D03043O00496E697403063O004E6577546162030D3O00424C55454E4947485420746162030A3O004E657753656374696F6E03143O00424C55454E4947485420436F6D706F6E656E7473033D3O00E0B895E0B8B1E0B8A7E0B980E0B8A3E0B8B7E0B988E0B8ADE0B887E0B981E0B8AAE0B887202F20455350206C6967687420F09F9486206374726C2B6820034E3O0020E0B88AE0B8B7E0B988E0B8ADE0B89EE0B8A3E0B989E0B8ADE0B8A1E0B980E0B8A5E0B8B7E0B8ADE0B894E0B8A3E0B8B0E0B8A2E0B8B0202F204553502042415220F09FA78A206374726C2B622003093O00636F726F7574696E6503043O007772617003093O0057617465726D61726B03153O00424C55454E49474854206578616D706C65207C207603073O0076657273696F6E2O033O00207C20030B3O00476574557365726E616D6503093O00207C2072616E6B3A2003043O0072616E6B030C3O00412O6457617465726D61726B03053O006670733A202O033O00667073030A3O006C6F6164737472696E6703043O0067616D6503073O00482O7470476574033B3O00682O7470733A2O2F7261772E67697468756275736572636F6E74656E742E636F6D2F436F6E7369732O742F55692F6D61696E2F556E4C65616B6564030F3O0046522O45205649502O20F02O9FA220030A3O004E65774B657962696E6403093O004B657962696E64203103043O00456E756D03073O004B6579436F646503083O005269676874416C7403063O00546F2O676C65030A3O00412O644B657962696E64030B3O004C656674436F6E74726F6C03093O004E657742752O746F6E03063O0042752O746F6E03083O004E65774C6162656C030D3O004578616D706C65206C6162656C03043O006C656674030E3O004578616D706C6520746F2O676C65030C3O005269676874436F6E74726F6C0030012O00123B3O00014O0032000100183O0026143O002E0001000200040B3O002E000100123B001900013O0026140019000F0001000300040B3O000F0001002036001A0006000400123B001C00054O0011001D5O00023E001E6O002F001A001E00022O0013000D001A3O00123B3O00063O00040B3O002E00010026140019001E0001000100040B3O001E0001002036001A0006000400123B001C00074O0011001D5O00023E001E00014O0033001A001E00024O000A001A3O00202O001A0006000400122O001C00086O001D5O00023E001E00024O002F001A001E00022O0013000B001A3O00123B001900093O000E30000900050001001900040B3O00050001002036001A0006000400123B001C000A4O0011001D5O00023E001E00034O0033001A001E00024O000B001A3O00202O001A0006000400122O001C000B6O001D5O00023E001E00044O002F001A001E00022O0013000C001A3O00123B001900033O00040B3O000500010026143O00370001000C00040B3O0037000100203600190004000D00122C001B000E3O00122O001C00063O00122O001D000F6O0019001D00024O001800193O00044O002E2O010026143O00630001000900040B3O0063000100123B001900013O002614001900550001000100040B3O00550001002036001A000100102O0008001A000200024O0004001A3O00122O001A00113O00122O001B00013O00122O001C00123O00042O001A0054000100123B001E00014O0032001F001F3O002614001E00450001000100040B3O00450001001219002000133O00201E00200020001400122O002100156O00200002000100202O00200004000D00122O002200163O00122O002300023O00122O002400176O0020002400024O001F00203O00044O0053000100040B3O0045000100043A001A0043000100123B001900093O0026140019005B0001000900040B3O005B000100301B000100180019002036001A0001001A2O0003001A0002000100123B001900033O0026140019003A0001000300040B3O003A0001001219001A00143O00123B001B00094O0003001A0002000100123B3O00033O00040B3O0063000100040B3O003A00010026143O00AD0001001B00040B3O00AD000100123B001900013O002614001900830001000900040B3O00830001002036001A0006001C001224001C001D3O00122O001D001E3O00122O001E001F3O00122O001F00203O00122O002000216O002100016O00225O00023E002300054O0031001A002300024O0015001A3O00202O001A0006002200122O001C00233O00122O001D00246O001E00043O00122O001F00253O00122O002000263O00122O002100253O00122O002200254O001C001E0004000100023E001F00064O0016001A001F000200202O001A001A002700122O001C00266O001A001C00024O0016001A3O00122O001900033O002614001900930001000300040B3O00930001002036001A00060028001218001C00293O00122O001D001E6O001E00013O00122O001F002A6O00203O000300302O0020002B000900302O0020002C002D00302O0020002E001100023E002100074O002F001A002100022O00130017001A3O00123B3O000C3O00040B3O00AD0001002614001900660001000100040B3O00660001002036001A0006001C001224001C002F3O00122O001D001E3O00122O001E00303O00122O001F00203O00122O002000316O002100016O00225O00023E002300084O001A001A002300024O0013001A3O00202O001A0006001C00122O001C00323O00122O001D001E3O00122O001E00333O00122O001F00203O00122O002000346O002100016O00225O00023E002300094O002F001A002300022O00130014001A3O00123B001900093O00040B3O006600010026143O00C70001000300040B3O00C700010020360019000100352O000F0019000200024O000500193O00202O00190005003600122O001B00376O0019001B00024O000600193O00202O00190006003800122O001B00396O0019001B00024O000700193O00203600190006000400123B001B003A4O0011001C5O00023E001D000A4O00330019001D00024O000800193O00202O00190006000400122O001B003B6O001C5O00023E001D000B4O002F0019001D00022O0013000900193O00123B3O00023O0026143O00F60001000100040B3O00F6000100123B001900013O002614001900D50001000300040B3O00D50001001219001A003C3O002001001A001A003D000607001B000C000100022O00133O00034O00133O00014O0027001A000200022O0005001A0001000100123B3O00093O00040B3O00F60001002614001900E90001000900040B3O00E90001002036001A0001003E00122D001C003F3O00202O001D0001004000122O001E00413O00202O001F000100424O001F0002000200122O002000433O00202O0021000100444O001C001C00214O001A001C00024O0002001A3O002036001A00020045001204001C00463O00202O001D000100474O001C001C001D4O001A001C00024O0003001A3O00122O001900033O002614001900CA0001000100040B3O00CA0001001219001A00483O001209001B00493O00202O001B001B004A00122O001D004B6O001B001D6O001A3O00024O001A000100024O0001001A3O00302O00010044004C00122O001900093O00044O00CA00010026143O00020001000600040B3O0002000100123B001900013O002614001900062O01000300040B3O00062O01002036001A0006004D00123B001C004E3O001219001D004F3O002001001D001D0050002001001D001D0051000607001E000D000100012O00133O00054O002F001A001E00022O00130012001A3O00123B3O001B3O00040B3O00020001000E30000900192O01001900040B3O00192O01002036001A0006000400123B001C00524O0011001D5O00023E001E000E4O002B001A001E000200202O001A001A005300122O001C004F3O00202O001C001C005000202O001C001C00544O001A001C00024O0010001A3O00202O001A0006005500122O001C00563O00023E001D000F4O002F001A001D00022O00130011001A3O00123B001900033O002614001900F90001000100040B3O00F90001002036001A00060057001228001C00583O00122O001D00596O001A001D00024O000E001A3O00202O001A0006000400122O001C005A6O001D5O00023E001E00104O0035001A001E000200202O001A001A005300122O001C004F3O00202O001C001C005000202O001C001C005B4O001A001C00024O000F001A3O00122O001900093O00044O00F9000100040B3O000200012O000E8O00253O00013O00113O00063O00030A3O006C6F6164737472696E6703043O0067616D6503073O00482O7470476574034F3O00682O7470733A2O2F7261772E67697468756275736572636F6E74656E742E636F6D2F4E696E654E6967687464656D6F6D6E696768742F73786E6764756875642F6D61696E2F61696D626F742E6C756103053O007072696E7403163O0041696D626F74205363726970742064697361626C6564010E3O00064O000A00013O00040B3O000A0001001219000100013O00122E000200023O00202O00020002000300122O000400046O000200046O00013O00024O00010001000100044O000D0001001219000100053O00123B000200064O00030001000200012O00253O00017O00063O00030A3O006C6F6164737472696E6703043O0067616D6503073O00482O747047657403513O00682O7470733A2O2F7261772E67697468756275736572636F6E74656E742E636F6D2F4E696E654E6967687464656D6F6D6E696768742F73786E6764756875642F6D61696E2F6573706672616D652E6C756103053O007072696E7403133O00455350205363726970742064697361626C6564010E3O00064O000A00013O00040B3O000A0001001219000100013O00122E000200023O00202O00020002000300122O000400046O000200046O00013O00024O00010001000100044O000D0001001219000100053O00123B000200064O00030001000200012O00253O00017O00063O00030A3O006C6F6164737472696E6703043O0067616D6503073O00482O747047657403503O00682O7470733A2O2F7261772E67697468756275736572636F6E74656E742E636F6D2F4E696E654E6967687464656D6F6D6E696768742F73786E6764756875642F6D61696E2F6573706C696E652E6C756103053O007072696E7403133O00455350205363726970742064697361626C6564010E3O00064O000A00013O00040B3O000A0001001219000100013O00122E000200023O00202O00020002000300122O000400046O000200046O00013O00024O00010001000100044O000D0001001219000100053O00123B000200064O00030001000200012O00253O00017O00063O00030A3O006C6F6164737472696E6703043O0067616D6503073O00482O7470476574034B3O00682O7470733A2O2F7261772E67697468756275736572636F6E74656E742E636F6D2F4E696E654E6967687464656D6F6D6E696768742F73786E6764756875642F6D61696E2F74702E6C756103053O007072696E7403133O00455350205363726970742064697361626C6564010E3O00064O000A00013O00040B3O000A0001001219000100013O00122E000200023O00202O00020002000300122O000400046O000200046O00013O00024O00010001000100044O000D0001001219000100053O00123B000200064O00030001000200012O00253O00017O00063O00030A3O006C6F6164737472696E6703043O0067616D6503073O00482O7470476574034C3O00682O7470733A2O2F7261772E67697468756275736572636F6E74656E742E636F6D2F4E696E654E6967687464656D6F6D6E696768742F73786E6764756875642F6D61696E2F666C792E6C756103053O007072696E7403133O00466C79205363726970742064697361626C6564010E3O00064O000A00013O00040B3O000A0001001219000100013O00122E000200023O00202O00020002000300122O000400046O000200046O00013O00024O00010001000100044O000D0001001219000100053O00123B000200064O00030001000200012O00253O00017O00013O0003053O007072696E7401043O001219000100014O001300026O00030001000200012O00253O00017O00013O0003053O007072696E7401043O001219000100014O001300026O00030001000200012O00253O00017O00013O0003053O007072696E7401043O001219000100014O001300026O00030001000200012O00253O00017O00013O0003053O007072696E7401043O001219000100014O001300026O00030001000200012O00253O00017O00013O0003053O007072696E7401043O001219000100014O001300026O00030001000200012O00253O00017O00063O00030A3O006C6F6164737472696E6703043O0067616D6503073O00482O7470476574034C3O00682O7470733A2O2F7261772E67697468756275736572636F6E74656E742E636F6D2F4E696E654E6967687464656D6F6D6E696768742F73786E6764756875642F6D61696E2F6573702E6C756103053O007072696E74033D3O00E0B895E0B8B1E0B8A7E0B980E0B8A3E0B8B7E0B988E0B8ADE0B887E0B981E0B8AAE0B887202F20455350206C6967687420F09F9486206374726C2B6820010E3O00064O000A00013O00040B3O000A0001001219000100013O00122E000200023O00202O00020002000300122O000400046O000200046O00013O00024O00010001000100044O000D0001001219000100053O00123B000200064O00030001000200012O00253O00017O00063O00030A3O006C6F6164737472696E6703043O0067616D6503073O00482O7470476574034F3O00682O7470733A2O2F7261772E67697468756275736572636F6E74656E742E636F6D2F4E696E654E6967687464656D6F6D6E696768742F73786E6764756875642F6D61696E2F6573706261722E6C756103053O007072696E7403133O00455350205363726970742064697361626C6564010E3O00064O000A00013O00040B3O000A0001001219000100013O00122E000200023O00202O00020002000300122O000400046O000200046O00013O00024O00010001000100044O000D0001001219000100053O00123B000200064O00030001000200012O00253O00017O00053O0003043O0077616974026O00E83F03043O005465787403053O006670733A202O033O00667073000E3O0012193O00013O00123B000100024O00273O0002000200064O000D00013O00040B3O000D00012O00177O0020225O000300122O000200046O000300013O00202O0003000300054O0002000200036O0002000100046O00012O00253O00017O00033O00030D3O005570646174654B657962696E6403043O00456E756D03073O004B6579436F646501074O003900015O00202O00010001000100122O000300023O00202O0003000300034O000300036O0001000300016O00017O00053O00028O0003023O006F6E2O033O006F2O6603053O007072696E7403043O0074776F2001123O00123B000100014O0032000200023O002614000100020001000100040B3O0002000100064O000900013O00040B3O0009000100123B000300023O00063C0002000A0001000300040B3O000A000100123B000200033O001219000300043O00121D000400056O000500026O0004000400054O00030002000100044O0011000100040B3O000200012O00253O00017O00023O0003053O007072696E742O033O006F6E6500043O0012193O00013O00123B000100024O00033O000200012O00253O00017O00053O00028O0003023O006F6E2O033O006F2O6603053O007072696E7403043O006F6E652001123O00123B000100014O0032000200023O002614000100020001000100040B3O0002000100064O000900013O00040B3O0009000100123B000300023O00063C0002000A0001000300040B3O000A000100123B000200033O001219000300043O00121D000400056O000500026O0004000400054O00030002000100044O0011000100040B3O000200012O00253O00017O00", GetFEnv(), ...);
