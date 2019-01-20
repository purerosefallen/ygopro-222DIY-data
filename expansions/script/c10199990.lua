--我靠卡
local m=10199990
local cm=_G["c"..m]
if not RealSclVersion then
	RealSclVersion=RealSclVersion or {}
	rsv=RealSclVersion 
--  "Set Core Outsorced" 
	RealSclVersion.CardFunction={}
	rscf=RealSclVersion.CardFunction
	RealSclVersion.GroupFunction={}
	rsgf=RealSclVersion.GroupFunction 
	RealSclVersion.EffectFunction={}
	rsef=RealSclVersion.GroupFunction 
	RealSclVersion.ZoneSequenceFunction={}
	rszsf=RealSclVersion.ZoneSequenceFunction
	RealSclVersion.OtherFunction={}
	rsof=RealSclVersion.OtherFunction
	RealSclVersion.SummonFunction={}
	rssf=RealSclVersion.SummonFunction
	RealSclVersion.Value={}
	rsval=RealSclVersion.Value
	RealSclVersion.Condition={}
	rscon=RealSclVersion.Condition
	RealSclVersion.Cost={}
	rscost=RealSclVersion.Cost

--  "Set Series Outsorced" 
  --[[rsv.Series1={
		"rsdka" =   "Dakyria"
		"rsdio" =   "Diablo"
		"rsnr"  =   "NightRaven"
		"rsul"  =   "Utoland"
		"rsxb"  =   "XB"
				}--]]

--  "Set Other Variables" 
	rscf.fieldinfo={}

-------------##########RSV variable###########-----------------
	rsv.reset_est=RESET_EVENT+RESETS_STANDARD 
	rsv.reset_est_d=RESET_EVENT+RESETS_STANDARD+RESET_DISABLE 
	rsv.reset_pend=RESET_PHASE+PHASE_END  
	rsv.reset_est_pend=rsv.reset_est + rsv.reset_pend 
	rsv.reset_ered=RESET_EVENT+RESETS_REDIRECT 

	rsreset_est=RESET_EVENT+RESETS_STANDARD 
	rsreset_pend=RESET_PHASE+PHASE_END  
	rsreset_est_pend=rsreset_est +  rsreset_pend

	rsv.flag_tg_d=EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY 
	rsv.flag_dsp_d=EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY 
	rsv.flag_dsp_tg=EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET rsv.flag_dsp_tg_d=rsv.flag_tg_d+EFFECT_FLAG_DAMAGE_STEP 
	rsv.flag_dsp_dcal=EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_STEP 

	rsv.cate_s_th=CATEGORY_SEARCH+CATEGORY_TOHAND 
	rsv.cate_neg_des=CATEGORY_NEGATE+CATEGORY_DESTROY 

-----------######Quick Effect Single Val Effect######---------------
--Single Val Effect: Base set
function rsef.SV(cardtbl,code,val,con,range,resettbl,flag,desctbl,ctlimittbl)
	local flagtbl1={ EFFECT_UPDATE_ATTACK,EFFECT_UPDATE_DEFENSE,EFFECT_SET_ATTACK,EFFECT_SET_DEFENSE,EFFECT_IMMUNE_EFFECT,EFFECT_CANNOT_BE_BATTLE_TARGET,EFFECT_CANNOT_BE_EFFECT_TARGET }
	local flagtbl2={ EFFECT_CHANGE_LEVEL,EFFECT_CHANGE_RANK,EFFECT_UPDATE_LEVEL,EFFECT_UPDATE_RANK }
	local tf1,k1=rsof.Table_List(flagtbl1,code)
	local tf2,k2=rsof.Table_List(flagtbl2,code)
	if tf1 or (tf2 and not resettbl) then 
		if not flag then flag=EFFECT_FLAG_SINGLE_RANGE 
		elseif flag and flag&EFFECT_FLAG_SINGLE_RANGE ==0 then flag=flag+EFFECT_FLAG_SINGLE_RANGE 
		end
	end
	if desctbl and flag&EFFECT_FLAG_CLIENT_HINT ==0 then flag=flag+EFFECT_FLAG_CLIENT_HINT end
	return rsef.Register(cardtbl,desctbl,nil,flag,EFFECT_TYPE_SINGLE,code,range,ctlimittbl,con,nil,nil,nil,val,nil,nil,resettbl)
end
--Single Val Effect: Cannot destroed 
function rsef.SV_INDESTRUCTABLE(cardtbl,indstype,val,con,resettbl,flag,desctbl,range,ctlimittbl)
	local effectcode=0
	local codetbl1={"battle","effect","ct"}
	local codetbl2={ EFFECT_INDESTRUCTABLE_BATTLE,EFFECT_INDESTRUCTABLE_EFFECT,EFFECT_INDESTRUCTABLE_COUNT }
	for k,v in ipairs(codetbl1) do
		if v==indstype then effectcode=codetbl2[k] break end
	end
	if not val then
		if indstype~=EFFECT_INDESTRUCTABLE_COUNT then
			val=1
		else
			val=rsval.indbae
		end
	end
	if not range then range=rsef.GetRegisterRange(cardtbl) end
	return rsef.SV(cardtbl,effectcode,val,con,range,resettbl,flag,desctbl,ctlimittbl)
end
--Single Val Effect: Immue effects
function rsef.SV_IMMUNE_EFFECT(cardtbl,val,con,resettbl,flag,desctbl,range)
	if not val then val=rsval.imes end
	if not range then range=rsef.GetRegisterRange(cardtbl) end
	return rsef.SV(cardtbl,EFFECT_IMMUNE_EFFECT,val,con,range,resettbl,flag,desctbl)
end
--Single Val Effect: Update some buff attribute 
function rsef.SV_UPDATE(cardtbl,uptypetbl,valtbl,con,resettbl,flag,desctbl,range)
	local codetbl1={"atk","def","lv","rk","ls","rs"}
	local codetbl2={ EFFECT_UPDATE_ATTACK,EFFECT_UPDATE_DEFENSE,EFFECT_UPDATE_LEVEL,EFFECT_UPDATE_RANK,EFFECT_UPDATE_LSCALE,EFFECT_UPDATE_RSCALE } 
	local effectcodetbl,effectvaluetbl=rsof.Table_Suit(uptypetbl,codetbl1,codetbl2,valtbl)
	local resulteffecttbl={}
	for k,effectcode in ipairs(effectcodetbl) do
		if not range then
			if effectcode~=EFFECT_UPDATE_LSCALE and effectcode~=EFFECT_UPDATE_RSCALE then range=LOCATION_MZONE 
			else range=LOCATION_PZONE 
			end
		end
		if effectvaluetbl[k] and effectvaluetbl[k]~=0 then
			local e1=rsef.SV(cardtbl,effectcode,effectvaluetbl[k],con,range,resettbl,flag,desctbl)
			table.insert(resulteffecttbl,e1)
		end
	end
	return table.unpack(resulteffecttbl)
end 
--Single Val Effect: Directly set ATK & DEF 
function rsef.SV_SET(cardtbl,settypetbl,valtbl,con,resettbl,flag,desctbl)
	local codetbl1={"atk","batk","atkf","def","bdef","deff"}
	local codetbl2={ EFFECT_SET_ATTACK,EFFECT_SET_BASE_ATTACK,EFFECT_SET_ATTACK_FINAL,EFFECT_SET_DEFENSE,EFFECT_SET_BASE_DEFENSE,EFFECT_SET_DEFENSE_FINAL } 
	local effectcodetbl,effectvaluetbl=rsof.Table_Suit(settypetbl,codetbl1,codetbl2,valtbl)
	local resulteffecttbl={}
	for k,effectcode in ipairs(effectcodetbl) do
		if effectvaluetbl[k] then
			local e1=rsef.SV(cardtbl,effectcode,effectvaluetbl[k],con,LOCATION_MZONE,resettbl,flag,desctbl)
			table.insert(resulteffecttbl,e1)
		end
	end
	return table.unpack(resulteffecttbl)
end
--Single Val Effect: Directly set other card attribute,except ATK & DEF
function rsef.SV_CHANGE(cardtbl,changetypetbl,valtbl,con,resettbl,flag,desctbl,range)
	local codetbl1={"lv","lvf","rk","rkf","code","att","race","type","fusatt","ls","rs"}
	local codetbl2={ EFFECT_CHANGE_LEVEL,EFFECT_CHANGE_LEVEL_FINAL,EFFECT_CHANGE_RANK,EFFECT_CHANGE_RANK_FINAL,EFFECT_CHANGE_CODE,EFFECT_CHANGE_ATTRIBUTE,EFFECT_CHANGE_RACE,EFFECT_CHANGE_TYPE,EFFECT_CHANGE_FUSION_ATTRIBUTE,EFFECT_CHANGE_LSCALE,EFFECT_CHANGE_RSCALE } 
	local effectcodetbl,effectvaluetbl=rsof.Table_Suit(changetypetbl,codetbl1,codetbl2,valtbl)
	local resulteffecttbl={}
	for k,effectcode in ipairs(effectcodetbl) do
		if not range then
			if effectcode~=EFFECT_CHANGE_LSCALE and uptype~=EFFECT_CHANGE_RSCALE then range=LOCATION_MZONE 
			else range=LOCATION_PZONE 
			end
		end
		if effectvaluetbl[k] then
			local e1=rsef.SV(cardtbl,effectcode,effectvaluetbl[k],con,range,resettbl,flag,desctbl)
			table.insert(resulteffecttbl,e1)
		end
	end
	return table.unpack(resulteffecttbl)
end
--Single Val Effect: Add some card attribute
function rsef.SV_ADD(cardtbl,addtypetbl,valtbl,con,resettbl,flag,desctbl,range)
	local codetbl1={"att","race","code","set","type","fusatt","fuscode","fusset","linkatt","linkrace","linkcode","linkset"}
	local codetbl2={ EFFECT_ADD_ATTRIBUTE,EFFECT_ADD_RACE,EFFECT_ADD_CODE,EFFECT_ADD_SETCODE,EFFECT_ADD_TYPE,EFFECT_ADD_FUSION_ATTRIBUTE,EFFECT_ADD_FUSION_CODE,EFFECT_ADD_FUSION_SETCODE,EFFECT_ADD_LINK_ATTRIBUTE,EFFECT_ADD_LINK_RACE,EFFECT_ADD_LINK_CODE,EFFECT_ADD_LINK_SETCODE }
	local effectcodetbl,effectvaluetbl=rsof.Table_Suit(addtypetbl,codetbl1,codetbl2,valtbl)
	local resulteffecttbl={}
	for k,effectcode in ipairs(effectcodetbl) do
		if not range then range=rsef.GetRegisterRange(cardtbl) end
		if effectvaluetbl[k] then
			local e1=rsef.SV(cardtbl,effectcode,effectvaluetbl[k],con,range,resettbl,flag,desctbl)
			table.insert(resulteffecttbl,e1)
		end
	end
	return table.unpack(resulteffecttbl)
end
--Single Val Effect: Material limit
function rsef.SV_CANNOT_BE_MATERIAL(cardtbl,lmattypetbl,valtbl,con,resettbl,flag,desctbl,range)
	local codetbl1={"fus","syn","xyz","link"}
	local codetbl2={ EFFECT_CANNOT_BE_FUSION_MATERIAL,EFFECT_CANNOT_BE_SYNCHRO_MATERIAL,EFFECT_CANNOT_BE_XYZ_MATERIAL,EFFECT_CANNOT_BE_LINK_MATERIAL }
	if not valtbl then valtbl=1 end
	local effectcodetbl,effectvaluetbl=rsof.Table_Suit(lmattypetbl,codetbl1,codetbl2,valtbl)
	local resulteffecttbl={}
	for k,effectcode in ipairs(effectcodetbl) do
		local e1=rsef.SV(cardtbl,effectcode,effectvaluetbl[k],con,range,resettbl,flag,desctbl)
		table.insert(resulteffecttbl,e1)
	end
	return table.unpack(resulteffecttbl)
end 
--Single Val Effect: Cannot be battle or card effect target
function rsef.SV_CANNOT_BE_TARGET(cardtbl,tgtype,val,con,resettbl,flag,desctbl,range)
	local effectcode=0
	local codetbl1={"battle","effect"}
	local codetbl2={ EFFECT_CANNOT_BE_BATTLE_TARGET,EFFECT_CANNOT_BE_EFFECT_TARGET }
	for k,v in ipairs(codetbl1) do
		if v==indstype then effectcode=codetbl2[k] break end
	end
	if not val then
		if tgtype==EFFECT_CANNOT_BE_BATTLE_TARGET then
			val=aux.imval1
		else
			val=1
		end
	end
	if not range then range=rsef.GetRegisterRange(cardtbl) end
	return rsef.SV(cardtbl,effectcode,val,con,range,resettbl,flag,desctbl,ctlimittbl)
end
--Single Val Effect: Other Limit
function rsef.SV_LIMIT(cardtbl,lotbl,valtbl,con,resettbl,flag,desctbl,range) 
	local codetbl1={"dis","dise","tri","atk","atkan","datk","ress","resns","td","th","cp"}
	local codetbl2={ EFFECT_DISABLE,EFFECT_DISABLE_EFFECT,EFFECT_CANNOT_TRIGGER,EFFECT_CANNOT_ATTACK,EFFECT_CANNOT_ATTACK_ANNOUNCE,EFFECT_CANNOT_DIRECT_ATTACK,EFFECT_UNRELEASABLE_SUM,EFFECT_UNRELEASABLE_NONSUM,EFFECT_CANNOT_TO_DECK,EFFECT_CANNOT_TO_HAND,EFFECT_CANNOT_CHANGE_POSITION }
	local effectcodetbl,effectvaluetbl=rsof.Table_Suit(lotbl,codetbl1,codetbl2,valtbl)
	local resulteffecttbl={}
	for k,effectcode in ipairs(effectcodetbl) do
		local e1=rsef.SV(cardtbl,effectcode,effectvaluetbl[k],con,range,resettbl,flag,desctbl)
		table.insert(resulteffecttbl,e1)
	end
	return table.unpack(resulteffecttbl)
end
--Single Val Effect: Leave field redirect 
function rsef.SV_REDIRECT(cardtbl,redtbl,valtbl,con,resettbl,flag,desctbl) 
	local codetbl1={"tg","td","th","leave"}
	local codetbl2={ EFFECT_TO_GRAVE_REDIRECT,EFFECT_TO_DECK_REDIRECT,EFFECT_TO_HAND_REDIRECT,EFFECT_LEAVE_FIELD_REDIRECT }
	if not valtbl then valtbl={ LOCATION_REMOVED } end
	local effectcodetbl,effectvaluetbl=rsof.Table_Suit(redtbl,codetbl1,codetbl2,valtbl)
	local resulteffecttbl={}
	--if not resettbl then resettbl=rsv.reset_ered end
	for k,effectcode in ipairs(effectcodetbl) do
		local e1=rsef.SV(cardtbl,effectcode,effectvaluetbl[k],con,nil,resettbl,flag,desctbl)
		table.insert(resulteffecttbl,e1)
	end
	return table.unpack(resulteffecttbl)
end
----------######Quick Effect Activate Effect######---------------
--Activate Effect: Base set
function rsef.ACT(cardtbl,desctbl,cate,flag,code,ctlimittbl,con,cost,tg,op,timingtbl,resettbl)
	if not desctbl then desctbl={m,1} end
	if not code then code=EVENT_FREE_CHAIN end
	return rsef.Register(cardtbl,desctbl,cate,flag,EFFECT_TYPE_ACTIVATE,code,nil,ctlimittbl,con,cost,tg,op,nil,nil,timingtbl,resettbl)
end   
-----------######Quick Effect Tigger Effect######---------------
--Self Tigger Effect No Force: Base set
function rsef.STO(cardtbl,desctbl,cate,flag,code,ctlimittbl,con,cost,tg,op,resettbl)
	return rsef.Register(cardtbl,desctbl,cate,flag,EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE,code,nil,ctlimittbl,con,cost,tg,op,nil,nil,nil,resettbl)
end 
--Self Tigger Effect Force: Base set
function rsef.STF(cardtbl,desctbl,cate,flag,code,ctlimittbl,con,cost,tg,op,resettbl)
	return rsef.Register(cardtbl,desctbl,cate,flag,EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE,code,nil,ctlimittbl,con,cost,tg,op,nil,nil,nil,resettbl)
end
--Field Tigger Effect No Force: Base set
function rsef.FTO(cardtbl,desctbl,cate,flag,code,range,ctlimittbl,con,cost,tg,op,resettbl)
	return rsef.Register(cardtbl,desctbl,cate,flag,EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD,code,range,ctlimittbl,con,cost,tg,op,nil,nil,nil,resettbl)
end
--Field Tigger Effect Force: Base set
function rsef.FTF(cardtbl,desctbl,cate,flag,code,range,ctlimittbl,con,cost,tg,op,resettbl)
	return rsef.Register(cardtbl,desctbl,cate,flag,EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD,code,range,ctlimittbl,con,cost,tg,op,nil,nil,nil,resettbl)
end
-----------######Quick Effect Ignition Effect######---------------
--Ignition Effect: Base set
function rsef.I(cardtbl,desctbl,cate,flag,range,ctlimittbl,con,cost,tg,op,resettbl)
	return rsef.Register(cardtbl,desctbl,cate,flag,EFFECT_TYPE_IGNITION,nil,range,ctlimittbl,con,cost,tg,op,nil,nil,nil,resettbl)
end
-----------######Quick Effect Quick Effect######---------------
--Quick Effect No Force: Base set
function rsef.QO(cardtbl,desctbl,cate,flag,code,range,ctlimittbl,con,cost,tg,op,timingtbl,resettbl)
	if not code then code=EVENT_FREE_CHAIN end
	return rsef.Register(cardtbl,desctbl,cate,flag,EFFECT_TYPE_QUICK_O,code,range,ctlimittbl,con,cost,tg,op,nil,nil,timingtbl,resettbl)
end 
--Quick Effect Force: Base set
function rsef.QF(cardtbl,desctbl,cate,flag,code,range,ctlimittbl,con,cost,tg,op,timingtbl,resettbl)
	if not code then code=EVENT_FREE_CHAIN end
	return rsef.Register(cardtbl,desctbl,cate,flag,EFFECT_TYPE_QUICK_F,code,range,ctlimittbl,con,cost,tg,op,nil,nil,timingtbl,resettbl)
end
-------------######Main Quick Effect Set#####-----------------
--Effect: Get reset, for some effect use like "banish it until XXXX"
function rsef.GetResetPhase(selfplayer,resetct,resetplayer,resetphase)
	if not resetphase then resetphase=PHASE_END end
	local currentphase=Duel.GetCurrentPhase()
	local currentplayer=Duel.GetTurnPlayer()
	local reset=RESET_PHASE+resetphase 
	if not resetct then
		return {0,1,resetplayer}
	end
	if resetct==0 then
		return {reset,1,currentplayer}
	end
	if resetplayer then
		if resetplayer==selfplayer then reset=reset+RESET_SELF_TURN 
		else reset=reset+RESET_OPPO_TURN 
		end
	end
	if resetct==1 then
		if currentphase<=resetphase and (not resetplayer or currentplayer==resetplayer) then
			return {reset,2,resetplayer}
		else
			return {reset,1,resetplayer}
		end
	end
	if resetct>1 then
		return {reset,resetct,resetplayer}
	end
end
--Effect: Get register card
function rsef.GetRegisterCard(cardtbl)
	local tc1,val2=nil
	local ignore=false
	if type(cardtbl)=="table" then
		tc1=cardtbl[1]
		if #cardtbl==1 then
			val2=tc1		  
		elseif #cardtbl==2 then
			if type(cardtbl[2]~="boolean") then
				val2=cardtbl[2]
			else
				val2=tc1
				ignore=cardtbl[2]
			end
		elseif #cardtbl==3 then
			val2=cardtbl[2]
			ignore=cardtbl[3]
		end
	else
	   tc1,val2=cardtbl,cardtbl
	end
	return tc1,val2,ignore
end
--Effect: Get default activate or apply range
function rsef.GetRegisterRange(cardtbl)
	local range=nil
	local tc1,tc2=rsef.GetRegisterCard(cardtbl)
	if tc2:IsType(TYPE_MONSTER) then range=LOCATION_MZONE 
	elseif tc2:IsType(TYPE_PENDULUM) then range=LOCATION_PZONE 
	elseif tc2:IsType(TYPE_FIELD) then range=LOCATION_FZONE 
	elseif tc2:IsType(TYPE_SPELL+TYPE_TRAP) then range=LOCATION_SZONE 
	end
	return range 
end
--Effect: Register Condition, Cost, Target and Operation 
function rsef.RegisterSolve(e,con,cost,tg,op)
	if con then
		e:SetCondition(con)
	end
	if cost then
		e:SetCondition(cost)
	end
	if tg then
		e:SetTarget(tg)
	end
	if op then
		e:SetOperation(op)
	end
end
--Effect: Register Effect Attributes
function rsef.Register(cardtbl,desctbl,cate,flag,effecttype,code,range,ctlimittbl,con,cost,tg,op,val,tgrangetbl,timingtbl,resettbl)
	local tc1,val2,ignore=rsef.GetRegisterCard(cardtbl)
	local e=Effect.CreateEffect(tc1)
	if desctbl then
		e:SetDescription(aux.Stringid(desctbl[1],desctbl[2]))
	end
	if cate then
		e:SetCategory(cate) 
	end
	if flag then
		e:SetProperty(flag)
	end
	if effecttype then
		e:SetType(effecttype)
	end
	if code then
		e:SetCode(code)
	end
	if range then
		e:SetRange(range)
	end
	if ctlimittbl then
		if type(ctlimittbl)=="table" then
			if #ctlimittbl==1 then
				e:SetCountLimit(ctlimittbl) 
			else
				e:SetCountLimit(ctlimittbl[1],ctlimittbl[2])
			end
		else
			e:SetCountLimit(ctlimittbl) 
		end
	end
	rsef.RegisterSolve(e,con,cost,tg,op)
	if val then
		e:SetValue(val)
	end
	if tgrangetbl then
		e:SetTargetRange(tgrangetbl[1],tgrangetbl[2])
	end
	if timingtbl then
		if type(timingtbl)=="table" then
			if #timingtbl==1 then
				e:SetHintTiming(timingtbl) 
			else
				e:SetHintTiming(timingtbl[1],timingtbl[2])
			end
		else
			e:SetHintTiming(timingtbl) 
		end
	end
	if resettbl then
		if type(resettbl)=="table" then
			if #resettbl==1 then
				e:SetReset(resettbl) 
			else
				e:SetReset(resettbl[1],resettbl[2])
			end
		else
			e:SetReset(resettbl) 
		end
	end
	if type(val2)=="number" and (val2==0 or val==1) then
		Duel.RegisterEffect(e,val2)
	else
		val2:RegisterEffect(e,ignore)
	end
	local fid=e:GetFieldID()
	return e,fid
end
-------------#######Summon Function#########-----------------
--Summon Condition: Is monster can normal or special summon
function rssf.SSCondition(cardtbl,isnsable,fun1,...)
	local tc1,tc2,ignore=rsef.GetRegisterCard(cardtbl)
	if not isnsable then
		tc2:EnableReviveLimit()
	end
	if not fun1 then fun1=aux.FALSE end
	local e1=Effect.CreateEffect(tc1)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.AND(fun1,...))
	tc2:RegisterEffect(e1,ignore)
end
--Summon Function: Quick Special Summon buff
--valtbl:{atk,def,lv} 
--waytbl:{way,resettbl} 
function rssf.SSBuff(valtbl,dis,trigger,leaveloc,waytbl)
	return function(c,corgval,e,tp)
		local g=Group.CreateGroup()
		local t=aux.GetValueType(corgval)
		if t=="Card" then g:AddCard(corgval) 
		elseif t=="Group" then g:Merge(corgval)
		end
		for tc in aux.Next(g) do
			local reset=((c==tc and #g==1) and  rsv.reset_est_d or rsv.reset_est)
			if valtbl then
				local atk,def,lv=valtbl[1],valtbl[2],valtbl[3]
				rsef.SV_SET({c,tc,true},"atk,def",{atk,def},nil,reset)
				rsef.SV_CHANGE({c,tc,true},"lv",lv,nil,reset)
			end
			if dis then
				rsef.SV_LIMIT({c,tc,true},"dis,dise",nil,nil,reset)
			end
			if trigger then
				rsef.SV_LIMIT({c,tc,true},"tri",nil,nil,reset)
			end
			if leaveloc then
				local flag=nil
				if c==tc then flag=EFFECT_CANNOT_DISABLE end
				if type(leaveloc)=="number" then
					rsef.SV_REDIRECT({c,tc,true},"leave",leaveloc,nil,rsv.reset_ered,flag)
				else
					rsef.SV_REDIRECT({c,tc,true},"leave",nil,nil,rsv.reset_ered,flag)
				end
			end
		end
		if waytbl then
			if type(waytbl)=="string" then waytbl={waytbl} end
			if type(waytbl)=="boolean" then waytbl={"des"} end
			local way=waytbl[1]
			local resettbl=waytbl[2]
			if not resettbl then resettbl={0,1} end
			local reset2,resetct,resetplayer=resettbl[1],resettbl[2],resettbl[3]
			local fid=c:GetFieldID()
			for tc in aux.Next(g) do
				tc:RegisterFlagEffect(c:GetOriginalCode(),rsv.reset_est+reset2,0,resetct,fid)
			end  
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END) 
			e1:SetCountLimit(1)
			if reset2 and reset2~=0 then
				e1:SetReset(reset2,resetct)
			end
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			g:KeepAlive()
			e1:SetLabelObject(g)
			e1:SetCondition(rssf.SSBuff_Con(fid,resetct,resetplayer))
			e1:SetOperation(rssf.SSBuff_Op(fid,way))
			Duel.RegisterEffect(e1,tp)   
		end
	end
end
function rssf.SSBuff_Filter(c,e,fid)
	return c:GetFlagEffectLabel(e:GetOwner():GetOriginalCode())==fid
end 
function rssf.SSBuff_Con(fid,resetct,resetplayer)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local g=e:GetLabelObject()
		local rg=g:Filter(rssf.SSBuff_Filter,nil,e,fid)
		if rg:GetCount()<=0 then 
			g:DeleteGroup() e:Reset() 
		return false 
		end
		if resetplayer and resetplayer~=Duel.GetTurnPlayer() then return false 
		end
		local tid1=rg:GetFirst():GetTurnID()
		local tid2=Duel.GetTurnCount()
		if resetct==0 and tid1~=tid2 then return false end
		if resetct>=1 and tid1==tid2 then return false end
		return true
	end
end
function rssf.SSBuff_Op(fid,way)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetOwner()
		Duel.Hint(HINT_CARD,0,c:GetOriginalCode())
		local g=e:GetLabelObject()
		local rg=g:Filter(rssf.SSBuff_Filter,nil,e,fid)
		if way=="des" then Duel.Destroy(rg,REASON_EFFECT)
		elseif way=="th" then Duel.SendtoHand(rg,nil,REASON_EFFECT)
		elseif way=="td" then Duel.SendtoDeck(rg,nil,2,REASON_EFFECT)
		elseif way=="tdt" then Duel.SendtoDeck(rg,nil,0,REASON_EFFECT)
		elseif way=="tdb" then Duel.SendtoDeck(rg,nil,1,REASON_EFFECT)
		elseif way=="rm" then Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
		elseif way=="rg" then Duel.SendtoGrave(rg,REASON_EFFECT)
		end
		if g:FilterCount(rssf.SSBuff_Filter,nil,e,fid)<=0 then
			g:DeleteGroup()
			e:Reset()
		end
	end
end 
--Summon Function: Duel.SpecialSummon + buff
function rssf.SpecialSummon(ssgorc,sstype,ssplayer,tplayer,ignorecon,ignorerevie,pos,zone,...)
	sstype,ssplayer,tplayer,ignorecon,ignorerevie,pos=rssf.GetSSDefaultParameter(sstype,ssplayer,tplayer,ignorecon,ignorerevie,pos)
	local ct=0
	if zone then
		ct=Duel.SpecialSummon(ssgorc,sstype,ssplayer,tplayer,ignorecon,ignorerevie,pos,zone)
	else
		ct=Duel.SpecialSummon(ssgorc,sstype,ssplayer,tplayer,ignorecon,ignorerevie,pos)
	end
	local g=Duel.GetOperatedGroup()
	if #g>0 then
		local c=g:GetFirst():GetReasonEffect():GetHandler()
		local functionlist={...}
		for _,fun in ipairs(functionlist) do
			fun(c,g,e,tp)
		end
	end 
	return ct,g 
end 
--Summon Function: Duel.SpecialSummonStep + buff 
function rssf.SpecialSummonStep(sscard,sstype,ssplayer,tplayer,ignorecon,ignorerevie,pos,zone,...) 
	sstype,ssplayer,tplayer,ignorecon,ignorerevie,pos=rssf.GetSSDefaultParameter(sstype,ssplayer,tplayer,ignorecon,ignorerevie,pos)
	local tf=false
	if zone then
		tf=Duel.SpecialSummonStep(sscard,sstype,ssplayer,tplayer,ignorecon,ignorerevie,pos,zone)
	else
		tf=Duel.SpecialSummonStep(sscard,sstype,ssplayer,tplayer,ignorecon,ignorerevie,pos)
	end
	if tf then
		local c=sscard:GetReasonEffect():GetHandler()
		local functionlist={...}
		for _,fun in ipairs(functionlist) do
			fun(c,sscard,e,tp)
		end
	end
	return tf,sscard
end
--Summon Function: Duel.SpecialSummon to either player's field + buff
function rssf.SpecialSummonEither(ssgorc,e,sstype,ssplayer,tplayer,ignorecon,ignorerevie,pos,zone2,...) 
	sstype,ssplayer,tplayer,ignorecon,ignorerevie,pos=rssf.GetSSDefaultParameter(sstype,ssplayer,tplayer,ignorecon,ignorerevie,pos)
	if not e then e=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_EFFECT) end
	local tp=ssplayer
	local zone={}
	local flag={}
	if not zone2 then
		zone2={[0]=0x1f,[1]=0x1f}
	end
	local ssg=Group.CreateGroup()
	local t=aux.GetValueType(ssgorc)
	if t=="Card" then ssg:AddCard(ssgorc) 
	elseif t=="Group" then ssg:Merge(ssgorc)
	end
	for sscard in aux.Next(ssg) do 
		local ava_zone=0
		for p=0,1 do
			zone[p]=zone2[p]&0xff
			local _,flag_tmp=Duel.GetLocationCount(p,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone[p])
			flag[p]=(~flag_tmp)&0x7f
		end
		for p=0,1 do
			if sscard:IsCanBeSpecialSummoned(e,sstype,ssplayer,ignorecon,ignorerevie,pos,p,zone[p]) then
				ava_zone=ava_zone|(flag[p]<<(p==tp and 0 or 16))
			end
		end
		if ava_zone<=0 then return 0,nil end
		local sel_zone=0
		for p=0,1 do
			if flag[p]==0 and ava_zone&(ava_zone-1)==0 then
				sel_zone=ava_zone
			end
		end
		if sel_zone==0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
			sel_zone=Duel.SelectDisableField(tp,1,LOCATION_MZONE,LOCATION_MZONE,0x00ff00ff&(~ava_zone))
		end
		local sump=0
		if sel_zone&0xff>0 then
			sump=tp
		else
			sump=1-tp
			sel_zone=sel_zone>>16
		end
		if rssf.SpecialSummonStep(sscard,sstype,ssplayer,sump,ignorecon,ignorerevie,pos,sel_zone,...) then
			ssg:AddCard(sscard)
		end
	end
	if #ssg>0 then
		Duel.SpecialSummonComplete()
	end
	return #ssg,ssg 
end
--Summon Function: Set Default Parameter
function rssf.GetSSDefaultParameter(sstype,ssplayer,tplayer,ignorecon,ignorerevie,pos)
	if not sstype then sstype=0 end
	if not ssplayer then ssplayer=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_PLAYER) end
	if not tplayer then tplayer=ssplayer end
	if not ignorecon then ignorecon=false end
	if not ignorerevie then ignorerevie=false end
	if not pos then pos=POS_FACEUP end
	return sstype,ssplayer,tplayer,ignorecon,ignorerevie,pos
end
-------------#######Quick Value#########-----------------
--value: SF_SSConditionValue - can only be special summoned from Extra Deck (if can only be XXX summoned from Extra Deck, must use aux.OR(xxxval,rsval.spconfe), but not AND)
function rsval.spconfe(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
--value: SF_SSConditionValue - can only be special summoned by self effects
function rsval.spcons(e,se,sp,st)
	return se:GetHandler()==e:GetHandler() and not se:IsHasProperty(EFFECT_FLAG_UNCOPYABLE)
end
--value: reason by battle or card effects
function rsval.indbae(e,re,r,rp)
	return r&REASON_BATTLE+REASON_EFFECT ~=0
end
--value: unaffected by opponent's card effects
function rsval.imoe(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
--value: unaffected by other card effects 
function rsval.imes(e,re)
	return re:GetOwner()~=e:GetOwner()
end
--value: unaffected by other card effects that do not target it
function rsval.imng2(e,re)
	local c=e:GetHandler()
	local ec=re:GetHandler()
	if re:GetOwner()==e:GetOwner() or ec:IsHasCardTarget(c) or (re:IsHasType(EFFECT_TYPE_ACTIONS) and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and c:IsRelateToEffect(re)) then return false
	end
	return true
end
--value: unaffected by opponent's card effects that do not target it
function rsval.imng2(e,re)
	local c=e:GetHandler()
	local ec=re:GetHandler()
	if re:GetHandlerPlayer()==e:GetHandlerPlayer() or ec:IsHasCardTarget(c) or (re:IsHasType(EFFECT_TYPE_ACTIONS) and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and c:IsRelateToEffect(re)) then return false
	end
	return true
end
-------------#########Quick Target###########-----------------

-------------#########Quick Cost###########-----------------
--cost: remove overlay card form self
function rscost.rmxyzs(ct1,ct2)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		 if not ct1 then ct1=e:GetHandler():GetOverlayCount() end
		 if not ct2 then ct2=ct1 end
		 if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,ct1,REASON_COST) end
		 e:GetHandler():RemoveOverlayCard(tp,ct1,ct2,REASON_COST)
	end
end
--cost: if the cost is relate to the effect, use this (real cost set in the target)
function rscost.reglabel(labelcount)
	if not labelcount then labelcount=100 end
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		e:SetLabel(labelcount)
		return true
	end
end
--cost: tribute self 
function rscost.releaseself(mzone,exmzone)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		if chk==0 then return c:IsReleasable() and (not mzone or Duel.GetMZoneCount(tp,c,tp)>0) and (not exmzone or Duel.GetLocationCountFromEx(tp,tp,c)>0) end
		Duel.Release(c,REASON_COST)
	end
end
--cost: register flag to limit activate (Quick Effect activates once per chain,e.g)
function rscost.regflag(flagcode,resettbl)
	if not resettbl then resettbl=RESET_CHAIN end
	if type[resettbl]~="table" then resettbl={resettbl} end
	local resetcount= resettbl[2]
	if not resetcount then resetcount=1 end
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		local code=c:GetOriginalCode()
		if not flagcode then flagcode=code end
		if chk==0 then return c:GetFlagEffect(flagcode)==0 end
		c:RegisterFlagEffect(flagcode,resettbl[1],0,resetcount)
	end
end
-------------#########Quick Condition#######-----------------
--Condition in Main Phase
function rscon.mp(e)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
--Condition in ADV or SP Summon Sucess
function rscon.sumtype(sumtbl,...)
	local functionlist={...}
	return function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if not sumtbl then sumtbl="sp" end
		local tf=false
		local codetbl1={"sp","adv","rit","fus","syn","xyz","link","pen"}
		local codetbl2={ SUMMON_TYPE_SPECIAL,SUMMON_TYPE_ADVANCE,SUMMON_TYPE_RITUAL,SUMMON_TYPE_FUSION,SUMMON_TYPE_SYNCHRO,SUMMON_TYPE_XYZ,SUMMON_TYPE_LINK,SUMMON_TYPE_PENDULUM }
		local stypetbl=rsof.Table_Suit(sumtbl,codetbl1,codetbl2)
		for _,stype in ipairs(stypetbl) do
			if c:IsSummonType(stype) then
				tf=true
			break 
			end 
		end 
		if not tf then return false end
		for _,fun in ipairs(functionlist) do
			if not re or not fun(re:GetHandler(),re) then return false end
		end
		return true 
	end
end 
-------------#########Zone&Sequence Function#####-----------------
--get excatly colomn zone, import the seq only
--zone[1][1] means your colomn Mzone, zone[1][2] means your colomn Szone, zone[1][3] means your colomn Mzone+Szone
--zone[2] is the same, zone[3] is zone[1]+zone[2] (all players)
--seq must use rsv.GetExcatlySequence to Get true sequence
function rszsf.GetExcatlyColumnZone(seq)
	local zone={}
	for i=0,1 do
		zone[i]={}
		if i==1 then seq=seq+16 end
		zone[i][1]=2^seq 
		zone[i][2]=(2^seq)*0x100
		zone[i][3]=zone[i][1]+zone[i][2]
	end
	zone[3]={}
	zone[3][1]=zone[1][1]+zone[2][1]
	zone[3][2]=zone[1][2]+zone[2][2]
	zone[3][3]=zone[1][3]+zone[2][3]
	return zone
end
--Get Surrounding Zone (up,down,left & right zone)
--p:Use this player's camera to see the sequence, default cp
--contains: Include itself's zone(mid)
--truezone: 1-p's zone must * 0x10000
function rszsf.GetSurroundingZone(c,p,truezone,contains)
	local seq=c:IsOnField() and c:GetSequence() or c:GetPreviousSequence()
	local loc=c:IsOnField() and c:GetLocation() or c:GetPreviousLocation()
	local cp=c:IsOnField() and c:GetControler() or c:GetPreviousControler()
	return rszsf.GetSurroundingZone2(seq,loc,cp,p,truezone,contains)
end
----Get Surrounding Zone (up,down,left & right zone)
--Use sequence to get Surrounding Zone
--p: p's sequence
--contains: Include itself's zone(mid)
--truezone: 1-p's zone must * 0x10000
function rszsf.GetSurroundingZone2(seq,loc,cp,p,truezone,contains)
	local nozone={[0]=0,[1]=0}
	if not p then p=cp end
	if not (type(truezone)=="boolean" and truezone==false) then truezone=true end
	if not (type(contains)=="boolean" and contains==false) then contains=true end
	if loc==LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND then
		Debug.Message("rszsf.GetSurroundingZone2: Location is not on field")
		return nozone,nozone,nozone 
	end
	if loc==LOCATION_PZONE or (loc==LOCATION_SZONE and seq>4) then
		return nozone,nozone,nozone
	end
	local mzone={[0]=0,[1]=0}
	local szone={[0]=0,[1]=0}
	if loc==LOCATION_MZONE then
		if seq==0 or seq==5 then mzone[cp]=mzone[cp]+0x2 end
		if seq==4 or seq==6 then mzone[cp]=mzone[cp]+0x8 end
		if seq>0 and seq<4 then mzone[cp]=mzone[cp]+2^(seq-1)+2^(seq+1) end
		if seq==5 then mzone[1-cp]=mzone[1-cp]+0x8 end
		if seq==6 then mzone[1-cp]=mzone[1-cp]+0x2 end
		if seq==1 then 
			mzone[cp]=mzone[cp]+0x20 
			mzone[1-cp]=mzone[1-cp]+0x40 
		end
		if seq==3 then 
			mzone[cp]=mzone[cp]+0x40 
			mzone[1-cp]=mzone[1-cp]+0x20 
		end
		if seq<5 then szone[cp]=szone[cp]+2^seq end
		if contains then mzone[cp]=mzone[cp]+2^seq end
	elseif loc==LOCATION_SZONE then
		if seq==0 then szone[cp]=szone[cp]+0x2 end
		if seq==4 then szone[cp]=szone[cp]+0x8 end   
		if seq>0 and seq<4 then szone[cp]=szone[cp]+2^(seq-1)+2^(seq+1) end
		mzone[cp]=mzone[cp]+2^seq
		if contains then szone[cp]=szone[cp]+2^seq end
	end
	szone[0]=szone[0]*0x100
	szone[1]=szone[1]*0x100
	if truezone then
		mzone[1-p]=mzone[1-p]*0x10000
		szone[1-p]=szone[1-p]*0x10000
	end
	local ozone={}
	for i=0,1 do
		ozone[i]=mzone[i]+szone[i]
	end
	return mzone,szone,ozone
end
-------------###########Group Function#########-----------------
--Get Surrounding Group (up,down,left & right zone)
--contains: Include itself's zone(mid)
function rsgf.GetSurroundingGroup(c,contains)
	local seq=c:IsOnField() and c:GetSequence() or c:GetPreviousSequence()
	local loc=c:IsOnField() and c:GetLocation() or c:GetPreviousLocation()
	local cp=c:IsOnField() and c:GetControler() or c:GetPreviousControler()
	return rsgf.GetSurroundingGroup2(seq,loc,cp,contains)
end
--Get Surrounding Group (up,down,left & right zone)
--contains: Include itself's zone(mid)
function rsgf.GetSurroundingGroup2(seq,loc,cp,contains)
	local f=function(c)
		return not c:IsLocation(LOCATION_SZONE) or c:GetSequence()<5
	end
	local mzone,szone,ozone=rszsf.GetSurroundingZone2(seq,loc,cp,cp,true,contains)
	local g=Duel.GetMatchingGroup(f,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local sg=Group.CreateGroup()
	local zone=ozone[0]+ozone[1]
	for tc in aux.Next(g) do 
		local seq=tc:GetSequence()
		if not tc:IsControler(cp) then seq=seq+16 end
		local tczone=2^seq
		if tc:IsLocation(LOCATION_SZONE) then tczone=tczone*0x100 end
		if tczone&zone ~=0 then 
			sg:AddCard(tc)
		end
	end
	return sg
end
--Group effect: Get Target Group for Operations
function rsgf.GetTargetGroup(...)
	local g,e,tp=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	local functionlist={...}
	local tg=g:Filter(rsgf.GetTargetGroupFilter,nil,e,functionlist)
	return tg,tg:GetFirst()
end
function rsgf.GetTargetGroupFilter(c,e,functionlist)
	if not c:IsRelateToEffect(e) then return false end
	for _,fun in ipairs(functionlist) do 
		if not fun(c,e,tp) then return false end
	end
	return true
end 
-------------###########Card Function#########-----------------
--Card effect: Set field info
function rscf.SetFieldInfo(c)
	local seq=c:IsOnField() and c:GetSequence() or c:GetPreviousSequence()
	local loc=c:IsOnField() and c:GetLocation() or c:GetPreviousLocation()
	local cp=c:IsOnField() and c:GetControler() or c:GetPreviousControler()
	if loc==LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND then
		Debug.Message("rscf.SetFieldInfo: Location is not on field.")
	else
		rscf.fieldinfo[c]={seq,loc,cp}
	end
end
--Card effect: Get field info
function rscf.GetFieldInfo(c)
	if not rscf.fieldinfo[c] or not rscf.fieldinfo[c][1] then
		Debug.Message("rscf.GetFieldInfo: Didn't use rscf.SetFieldInfo set field information")
		return nil
	end
	return rscf.fieldinfo[c][1],rscf.fieldinfo[c][2],rscf.fieldinfo[c][3]
end
--Card effect: Check if c is surrounding to tc 
function rscf.IsSurrounding(c,tc)
	if not tc:IsOnField() then return false end
	local g=rsgf.GetSurroundingGroup(tc,true)
	return g:IsContains(c)
end
--Card effect: Check if c is surrounding to tc, c is previous on field
function rscf.IsPreviousSurrounding(c,tc)
	local seq,loc,p=c:GetPreviousSequence(),c:GetPreviousLocation(),c:GetPreviousControler()
	if loc&LOCATION_ONFIELD==0 or not tc:IsOnField() then
		return false
	end
	local mzone,szone,ozone=rszsf.GetSurroundingZone(tc)
	local zone=ozone[0]+ozone[1]
	if p~=tc:GetControler() then seq=seq+16 end
	local czone=2^seq
	if loc==LOCATION_SZONE then czone=czone*0x100 end
	return czone&zone ~=0   
end
--Card effect: Get First Target Card for Operations
function rscf.GetTargetCard(...)
	local tc=Duel.GetFirstTarget()
	if not tc then return nil end
	local e,tp=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER) 
	if not tc:IsRelateToEffect(e) then return nil end
	local functionlist={...}
	for _,fun in ipairs(functionlist) do 
		if not fun(tc,e,tp) then return nil end
	end
	return tc
end
-------------#########RSV Other Function#######-----------------
--other link material bug repair
function Auxiliary.LCheckOtherMaterial(c,mg,lc)
	local le={c:IsHasEffect(EFFECT_EXTRA_LINK_MATERIAL)}
	if #le==0 then return true end
	for _,te in pairs(le) do
		local f=te:GetValue()
		if not f or f(te,lc,mg) then return true end
	end
	return false
end
--split the string, ues "," as delimiter
function rsof.Sting_Split(stringinput)  
	local delimiter=','
	local pos,arr = 0, {}  
	for st,sp in function() return string.find(stringinput, delimiter, pos, true) end do  
		table.insert(arr, string.sub(stringinput, pos, st - 1))  
		pos = sp + 1  
	end  
	table.insert(arr, string.sub(stringinput, pos))  
	return arr  
end  
--Sting to Table (for different formats)
--you can use "a,b,c" or {"a,b,c"} or {"a","b","c"} as same
function rsof.Sting_ToTable(value)
	local table1={}
	if type(value)=="string" then
		table1=rsof.Sting_Split(value)
	elseif type(value)=="table" then
		for _,v in ipairs(value) do
			local table2=rsof.Sting_Split(v)
			for _,v2 in ipairs(table2) do
				table.insert(table1,v2) 
			end
		end
	end
	return table1
end
--suit 2 tables (for rsv_E_SV)
function rsof.Table_Suit(value1,value2,value3,value4)
	local table1=rsof.Sting_ToTable(value1)
	local table2=rsof.Sting_ToTable(value2)
	local table3=value3
	local table4=value4
	if type(value4)~="table" then
		table4={value4}
	end
	local resulttbl1,resulttbl2={},{}
	for k1,v1 in ipairs(table1) do
		for k2,v2 in ipairs(table2) do
			if v1==v2 then
				table.insert(resulttbl1,value3[k2]) 
				if #table4==1 then
				   table.insert(resulttbl2,table4[1])
				else
				   table.insert(resulttbl2,table4[k1])
				end
			end
		end
	end
	return resulttbl1,resulttbl2
end
--other function: Find correct element in table
function rsof.Table_List(rtable,element)
	for k,v in ipairs(rtable) do
		if v==element then
			return true,k 
		end
	end
	return false,nil
end
--other function: N effects select 1
function rsof.SelectOption(p,...)
	local functionlist={...}
	local off=1
	local ops={}
	local opval={}
	for k,v in ipairs(functionlist) do
		if type(v)=="boolean" and v and k~=#functionlist then
			ops[off]=functionlist[k+1]
			opval[off-1]=(k+1)/2
			off=off+1
		end
	end
	if #ops<=0 then 
		return nil
	else
		local final=functionlist[#functionlist]
		if #ops==1 and type(final)=="boolean" and final then
			return opval[0]
		else
			local op=Duel.SelectOption(p,table.unpack(ops))
			return opval[op]
		end
	end
end
-------------------E-----N-----D--------------------------
end
------------########################-----------------
if cm then
function cm.initial_effect(c)
	
end
end