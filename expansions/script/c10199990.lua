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
	RealSclVersion.Target={}
	rstg=RealSclVersion.Target
	RealSclVersion.Category={}
	rscate=RealSclVersion.Category
	RealSclVersion.Reset={}
	rsreset=RealSclVersion.Reset
	RealSclVersion.Property={} 
	rsflag=RealSclVersion.Property
	RealSclVersion.Code={} 
	rscode=RealSclVersion.Code  

--  "Set Series Outsorced" 
  --[[rsv.Series1={
		"rsdka" =   "Dakyria"
		"rsdio" =   "Diablo"
		"rsnr"  =   "NightRaven"
		"rsul"  =   "Utoland"
		"rsxb"  =   "XB"
				}--]]

--  "Set Other Variables" 
  --[[rsv.Series2={
		"rssg"  =   "SexGun"
				}--]]

-------------##########RSV variable###########----------------

	rsreset.est=RESET_EVENT+RESETS_STANDARD 
	rsreset.est_d=RESET_EVENT+RESETS_STANDARD+RESET_DISABLE 
	rsreset.pend=RESET_PHASE+PHASE_END  
	rsreset.est_pend=rsreset.est +  rsreset.pend
	rsreset.ered=RESET_EVENT+RESETS_REDIRECT 

	rsflag.tg_d=EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY 
	rsflag.dsp_d=EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY 
	rsflag.dsp_tg=EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET 
	rsflag.dsp_dcal=EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_STEP 
	rsflag.ign_set=EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE 

	rscate.se_th=CATEGORY_SEARCH+CATEGORY_TOHAND 
	rscate.neg_des=CATEGORY_NEGATE+CATEGORY_DESTROY 

	rscf.fieldinfo={}

	rsflag.flaglist={ EFFECT_FLAG_CARD_TARGET,EFFECT_FLAG_PLAYER_TARGET,EFFECT_FLAG_DELAY,EFFECT_FLAG_DAMAGE_STEP,EFFECT_FLAG_DAMAGE_CAL,
	EFFECT_FLAG_IGNORE_IMMUNE,EFFECT_FLAG_SET_AVAILABLE,EFFECT_FLAG_IGNORE_RANGE,EFFECT_FLAG_SINGLE_RANGE,EFFECT_FLAG_BOTH_SIDE, 
	EFFECT_FLAG_UNCOPYABLE,EFFECT_FLAG_CANNOT_DISABLE,EFFECT_FLAG_CANNOT_NEGATE,EFFECT_FLAG_CLIENT_HINT,EFFECT_FLAG_LIMIT_ZONE,
	EFFECT_FLAG_ABSOLUTE_TARGET,EFFECT_FLAG_SPSUM_PARAM 
	}
	rscate.catelist={ CATEGORY_DESTROY,CATEGORY_RELEASE,CATEGORY_REMOVE,CATEGORY_TOHAND,CATEGORY_TODECK,
	CATEGORY_TOGRAVE,CATEGORY_DECKDES,CATEGORY_HANDES,CATEGORY_SUMMON,CATEGORY_SPECIAL_SUMMON,
	CATEGORY_TOKEN,CATEGORY_POSITION,CATEGORY_CONTROL,CATEGORY_DISABLE,CATEGORY_DISABLE_SUMMON,
	CATEGORY_DRAW,CATEGORY_SEARCH,CATEGORY_EQUIP,CATEGORY_DAMAGE,CATEGORY_RECOVER,
	CATEGORY_ATKCHANGE,CATEGORY_DEFCHANGE,CATEGORY_COUNTER,CATEGORY_COIN,CATEGORY_DICE, 
	CATEGORY_LEAVE_GRAVE,CATEGORY_LVCHANGE,CATEGORY_NEGATE,CATEGORY_ANNOUNCE,CATEGORY_FUSION_SUMMON,
	CATEGORY_TOEXTRA } 

-----------######Quick Effect Value Effect######---------------
--Single Val Effect: Base set
function rsef.SV(cardtbl,code,val,range,con,resettbl,flag,desctbl,ctlimittbl)
	if not flag then flag=0 end
	local flag2=rsef.GetRegisterProperty(flag)
	local flagtbl1={ EFFECT_UPDATE_ATTACK,EFFECT_UPDATE_DEFENSE,EFFECT_SET_ATTACK,EFFECT_SET_DEFENSE,EFFECT_IMMUNE_EFFECT,EFFECT_CANNOT_BE_BATTLE_TARGET,EFFECT_CANNOT_BE_EFFECT_TARGET }
	local flagtbl2={ EFFECT_CHANGE_LEVEL,EFFECT_CHANGE_RANK,EFFECT_UPDATE_LEVEL,EFFECT_UPDATE_RANK }
	local tf1=rsof.Table_List(flagtbl1,code)
	local tf2=rsof.Table_List(flagtbl2,code)
	if tf1 or (tf2 and not resettbl) then 
		if not flag2 then flag2=EFFECT_FLAG_SINGLE_RANGE 
		elseif flag2 and flag2&EFFECT_FLAG_SINGLE_RANGE ==0 then flag2=flag2+EFFECT_FLAG_SINGLE_RANGE 
		end
	end
	if desctbl and flag2&EFFECT_FLAG_CLIENT_HINT ==0 then flag2=flag2+EFFECT_FLAG_CLIENT_HINT end
	return rsef.Register(cardtbl,EFFECT_TYPE_SINGLE,code,desctbl,ctlimittbl,nil,flag2,range,con,nil,nil,nil,val,nil,nil,resettbl)
end
--Single Val Effect: Cannot destroed 
function rsef.SV_INDESTRUCTABLE(cardtbl,indstype,val,con,resettbl,flag,desctbl,ctlimittbl)
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
			val=rsval.indbae()
		end
	end
	if indstype==EFFECT_INDESTRUCTABLE_COUNT and not ctlimittbl then
		ctlimittbl=1
	end
	local range=rsef.GetRegisterRange(cardtbl)
	return rsef.SV(cardtbl,effectcode,val,range,con,resettbl,flag,desctbl,ctlimittbl)
end
--Single Val Effect: Immue effects
function rsef.SV_IMMUNE_EFFECT(cardtbl,val,con,resettbl,flag,desctbl)
	if not val then val=rsval.imes end
	local range=rsef.GetRegisterRange(cardtbl)
	return rsef.SV(cardtbl,EFFECT_IMMUNE_EFFECT,val,range,con,resettbl,flag,desctbl)
end
--Single Val Effect: Update some buff attribute 
function rsef.SV_UPDATE(cardtbl,uptypetbl,valtbl,con,resettbl,flag,desctbl)
	local codetbl1={"atk","def","lv","rk","ls","rs"}
	local codetbl2={ EFFECT_UPDATE_ATTACK,EFFECT_UPDATE_DEFENSE,EFFECT_UPDATE_LEVEL,EFFECT_UPDATE_RANK,EFFECT_UPDATE_LSCALE,EFFECT_UPDATE_RSCALE } 
	local effectcodetbl,effectvaluetbl=rsof.Table_Suit(uptypetbl,codetbl1,codetbl2,valtbl)
	local resulteffecttbl={}
	local range=nil
	for k,effectcode in ipairs(effectcodetbl) do 
		if not resettbl then
			if effectcode~=EFFECT_UPDATE_LSCALE and effectcode~=EFFECT_UPDATE_RSCALE then range=LOCATION_MZONE 
			else range=LOCATION_PZONE 
			end
		end
		if effectvaluetbl[k] and effectvaluetbl[k]~=0 then
			local e1=rsef.SV(cardtbl,effectcode,effectvaluetbl[k],range,con,resettbl,flag,desctbl)
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
			local e1=rsef.SV(cardtbl,effectcode,effectvaluetbl[k],nil,con,resettbl,flag,desctbl)
			table.insert(resulteffecttbl,e1)
		end
	end
	return table.unpack(resulteffecttbl)
end
--Single Val Effect: Directly set other card attribute,except ATK & DEF
function rsef.SV_CHANGE(cardtbl,changetypetbl,valtbl,con,resettbl,flag,desctbl)
	local codetbl1={"lv","lvf","rk","rkf","code","att","race","type","fusatt","ls","rs"}
	local codetbl2={ EFFECT_CHANGE_LEVEL,EFFECT_CHANGE_LEVEL_FINAL,EFFECT_CHANGE_RANK,EFFECT_CHANGE_RANK_FINAL,EFFECT_CHANGE_CODE,EFFECT_CHANGE_ATTRIBUTE,EFFECT_CHANGE_RACE,EFFECT_CHANGE_TYPE,EFFECT_CHANGE_FUSION_ATTRIBUTE,EFFECT_CHANGE_LSCALE,EFFECT_CHANGE_RSCALE } 
	local effectcodetbl,effectvaluetbl=rsof.Table_Suit(changetypetbl,codetbl1,codetbl2,valtbl)
	local resulteffecttbl={}
	local range=nil
	for k,effectcode in ipairs(effectcodetbl) do
		if not resettbl then
			if effectcode~=EFFECT_CHANGE_LSCALE and uptype~=EFFECT_CHANGE_RSCALE then range=LOCATION_MZONE 
			else range=LOCATION_PZONE 
			end
		end
		if effectvaluetbl[k] then
			local e1=rsef.SV(cardtbl,effectcode,effectvaluetbl[k],range,con,resettbl,flag,desctbl)
			table.insert(resulteffecttbl,e1)
		end
	end
	return table.unpack(resulteffecttbl)
end
--Single Val Effect: Add some card attribute
function rsef.SV_ADD(cardtbl,addtypetbl,valtbl,con,resettbl,flag,desctbl)
	local codetbl1={"att","race","code","set","type","fusatt","fuscode","fusset","linkatt","linkrace","linkcode","linkset"}
	local codetbl2={ EFFECT_ADD_ATTRIBUTE,EFFECT_ADD_RACE,EFFECT_ADD_CODE,EFFECT_ADD_SETCODE,EFFECT_ADD_TYPE,EFFECT_ADD_FUSION_ATTRIBUTE,EFFECT_ADD_FUSION_CODE,EFFECT_ADD_FUSION_SETCODE,EFFECT_ADD_LINK_ATTRIBUTE,EFFECT_ADD_LINK_RACE,EFFECT_ADD_LINK_CODE,EFFECT_ADD_LINK_SETCODE }
	local effectcodetbl,effectvaluetbl=rsof.Table_Suit(addtypetbl,codetbl1,codetbl2,valtbl)
	local resulteffecttbl={}
	for k,effectcode in ipairs(effectcodetbl) do
		local range=rsef.GetRegisterRange(cardtbl)
		if effectvaluetbl[k] then
			local e1=rsef.SV(cardtbl,effectcode,effectvaluetbl[k],range,con,resettbl,flag,desctbl)
			table.insert(resulteffecttbl,e1)
		end
	end
	return table.unpack(resulteffecttbl)
end
--Single Val Effect: Material limit
function rsef.SV_CANNOT_BE_MATERIAL(cardtbl,lmattypetbl,valtbl,con,resettbl,flag,desctbl)
	local codetbl1={"fus","syn","xyz","link"}
	local codetbl2={ EFFECT_CANNOT_BE_FUSION_MATERIAL,EFFECT_CANNOT_BE_SYNCHRO_MATERIAL,EFFECT_CANNOT_BE_XYZ_MATERIAL,EFFECT_CANNOT_BE_LINK_MATERIAL }
	if not valtbl then valtbl=1 end
	local effectcodetbl,effectvaluetbl=rsof.Table_Suit(lmattypetbl,codetbl1,codetbl2,valtbl)
	local resulteffecttbl={}
	for k,effectcode in ipairs(effectcodetbl) do
		local e1=rsef.SV(cardtbl,effectcode,effectvaluetbl[k],nil,con,resettbl,flag,desctbl)
		table.insert(resulteffecttbl,e1)
	end
	return table.unpack(resulteffecttbl)
end
--Single Val Effect: Cannot be battle or card effect target
function rsef.SV_CANNOT_BE_TARGET(cardtbl,tgtype,val,con,resettbl,flag,desctbl)
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
	local range=rsef.GetRegisterRange(cardtbl)
	return rsef.SV(cardtbl,effectcode,val,range,con,resettbl,flag,desctbl,ctlimittbl)
end
--Single Val Effect: Other Limit
function rsef.SV_LIMIT(cardtbl,lotbl,valtbl,con,resettbl,flag,desctbl) 
	local codetbl1={"dis","dise","tri","atk","atkan","datk","ress","resns","td","th","cp"}
	local codetbl2={ EFFECT_DISABLE,EFFECT_DISABLE_EFFECT,EFFECT_CANNOT_TRIGGER,EFFECT_CANNOT_ATTACK,EFFECT_CANNOT_ATTACK_ANNOUNCE,EFFECT_CANNOT_DIRECT_ATTACK,EFFECT_UNRELEASABLE_SUM,EFFECT_UNRELEASABLE_NONSUM,EFFECT_CANNOT_TO_DECK,EFFECT_CANNOT_TO_HAND,EFFECT_CANNOT_CHANGE_POSITION }
	local effectcodetbl,effectvaluetbl=rsof.Table_Suit(lotbl,codetbl1,codetbl2,valtbl)
	local resulteffecttbl={}
	local range=rsef.GetRegisterRange(cardtbl) 
	for k,effectcode in ipairs(effectcodetbl) do
		local e1=rsef.SV(cardtbl,effectcode,effectvaluetbl[k],range,con,resettbl,flag,desctbl)
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
	--if not resettbl then resettbl=rsreset.ered end
	for k,effectcode in ipairs(effectcodetbl) do
		local e1=rsef.SV(cardtbl,effectcode,effectvaluetbl[k],nil,con,resettbl,flag,desctbl)
		table.insert(resulteffecttbl,e1)
	end
	return table.unpack(resulteffecttbl)
end
--Field Val Effect: Base set
function rsef.FV(cardtbl,code,val,tg,tgrangetbl,range,con,resettbl,flag,desctbl,ctlimittbl)
	if not flag then flag=0 end
	local flag2=rsef.GetRegisterProperty(flag)
	if desctbl and flag2&EFFECT_FLAG_CLIENT_HINT ==0 then flag2=flag2+EFFECT_FLAG_CLIENT_HINT end
	return rsef.Register(cardtbl,EFFECT_TYPE_FIELD,code,desctbl,ctlimittbl,nil,flag2,range,con,nil,nil,nil,val,tgrangetbl,nil,resettbl)
end
--Field Val Effect: Updata some card attributes
function rsef.FV_UPDATE(cardtbl,uptypetbl,valtbl,tg,tgrangetbl,con,resettbl,flag,desctbl)
	local codetbl1={"atk","def","lv","rk","ls","rs"}
	local codetbl2={ EFFECT_UPDATE_ATTACK,EFFECT_UPDATE_DEFENSE,EFFECT_UPDATE_LEVEL,EFFECT_UPDATE_RANK,EFFECT_UPDATE_LSCALE,EFFECT_UPDATE_RSCALE } 
	local effectcodetbl,effectvaluetbl=rsof.Table_Suit(uptypetbl,codetbl1,codetbl2,valtbl)
	if not tgrangetbl then tgrangetbl={ LOCATION_MZONE,0 } end
	local resulteffecttbl={}
	local range=rsef.GetRegisterRange(cardtbl)
	for k,effectcode in ipairs(effectcodetbl) do 
		if effectvaluetbl[k] and effectvaluetbl[k]~=0 then
			local e1=rsef.SV(cardtbl,effectcode,effectvaluetbl[k],tg,tgrangetbl,range,con,resettbl,flag,desctbl)
			table.insert(resulteffecttbl,e1)
		end
	end
	return table.unpack(resulteffecttbl)  
end
--Field Val Effect: Cannot be battle or card effect target
function rsef.FV_CANNOT_BE_TARGET(cardtbl,tgtype,val,tg,tgrangetbl,con,resettbl,flag,desctbl)
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
	local range=rsef.GetRegisterRange(cardtbl)
	if not flag then flag=0 end
	local flag2=rsef.GetRegisterProperty(flag)
	if flag2&EFFECT_FLAG_IGNORE_IMMUNE ==0 then flag2=flag2+EFFECT_FLAG_IGNORE_IMMUNE end
	if not tgrangetbl then tgrangetbl={ LOCATION_MZONE,0 } end
	return rsef.FV(cardtbl,effectcode,val,tg,tgrangetbl,range,con,resettbl,flag2,desctbl,ctlimittbl)
end
--Field Val Effect: Cannot destroed 
function rsef.FV_INDESTRUCTABLE(cardtbl,indstype,val,tg,tgrangetbl,con,resettbl,flag,desctbl)
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
			val=rsval.indct()
		end
	end
	local range=rsef.GetRegisterRange(cardtbl)
	if not tgrangetbl then tgrangetbl={ LOCATION_MZONE,0 } end
	return rsef.FV(cardtbl,effectcode,val,tg,tgrangetbl,range,con,resettbl,flag,desctbl)
end
--Field Val Effect: Other Limit
function rsef.FV_LIMIT(cardtbl,lotbl,valtbl,tg,tgrangetbl,con,resettbl,flag,desctbl) 
	local codetbl1={"dis","dise","tri","atk","atkan","datk","ress","resns","td","th","cp","res"}
	local codetbl2={ EFFECT_DISABLE,EFFECT_DISABLE_EFFECT,EFFECT_CANNOT_TRIGGER,EFFECT_CANNOT_ATTACK,EFFECT_CANNOT_ATTACK_ANNOUNCE,EFFECT_CANNOT_DIRECT_ATTACK,EFFECT_CANNOT_RELEASE,EFFECT_UNRELEASABLE_SUM,EFFECT_UNRELEASABLE_NONSUM,EFFECT_CANNOT_TO_DECK,EFFECT_CANNOT_TO_HAND,EFFECT_CANNOT_CHANGE_POSITION }
	local effectcodetbl,effectvaluetbl=rsof.Table_Suit(lotbl,codetbl1,codetbl2,valtbl)
	local resulteffecttbl={}
	local range=rsef.GetRegisterRange(cardtbl) 
	if not tgrangetbl then tgrangetbl={ 0,LOCATION_MZONE } end
	for k,effectcode in ipairs(effectcodetbl) do 
		local e1=rsef.FV(cardtbl,effectcode,effectvaluetbl[k],tg,tgrangetbl,range,con,resettbl,flag,desctbl)
		table.insert(resulteffecttbl,e1)
	end
	return table.unpack(resulteffecttbl)
end
--Field Val Effect: Immue effects
function rsef.FV_IMMUNE_EFFECT(cardtbl,val,tg,tgrangetbl,con,resettbl,flag,desctbl)
	if not val then val=rsval.imes end
	local range=rsef.GetRegisterRange(cardtbl)
	if not tgrangetbl then tgrangetbl={ LOCATION_MZONE,0 } end
	return rsef.FV(cardtbl,EFFECT_IMMUNE_EFFECT,val,tg,tgrangetbl,range,con,resettbl,flag,desctbl)
end
--Field Val Effect: Leave field redirect 
function rsef.FV_REDIRECT(cardtbl,redtbl,valtbl,tg,tgrangetbl,con,resettbl,flag,desctbl) 
	local codetbl1={"tg","td","th","leave"}
	local codetbl2={ EFFECT_TO_GRAVE_REDIRECT,EFFECT_TO_DECK_REDIRECT,EFFECT_TO_HAND_REDIRECT,EFFECT_LEAVE_FIELD_REDIRECT }
	if not valtbl then valtbl={ LOCATION_REMOVED } end
	local effectcodetbl,effectvaluetbl=rsof.Table_Suit(redtbl,codetbl1,codetbl2,valtbl)
	local resulteffecttbl={}
	local range=rsef.GetRegisterRange(cardtbl)
	if not tgrangetbl then tgrangetbl={ 0,0xff } end
	if not flag then flag=0 end
	local flag2=rsef.GetRegisterProperty(flag)
	if flag2&EFFECT_FLAG_IGNORE_IMMUNE ==0 then flag2=flag2+EFFECT_FLAG_IGNORE_IMMUNE end
	if flag2&EFFECT_FLAG_SET_AVAILABLE ==0 then flag2=flag2+EFFECT_FLAG_SET_AVAILABLE end
	if flag2&EFFECT_FLAG_IGNORE_RANGE ==0 then flag2=flag2+EFFECT_FLAG_IGNORE_RANGE end 
	for k,effectcode in ipairs(effectcodetbl) do
		local e1=rsef.FV(cardtbl,effectcode,effectvaluetbl[k],tg,tgrangetbl,range,con,resettbl,flag2,desctbl)
		table.insert(resulteffecttbl,e1)
	end
	return table.unpack(resulteffecttbl)
end
----------######Quick Effect Activate Effect######---------------
--Activate Effect: Base set
function rsef.ACT(cardtbl,code,desctbl,ctlimittbl,cate,flag,con,cost,tg,op,timingtbl,resettbl)
	if not desctbl then desctbl={m,0} end
	if not code then code=EVENT_FREE_CHAIN end
	return rsef.Register(cardtbl,EFFECT_TYPE_ACTIVATE,code,desctbl,ctlimittbl,cate,flag,nil,con,cost,tg,op,nil,nil,timingtbl,resettbl)
end  
--Activate Effect: Equip Spell
function rsef.ACT_EQUIP(cardtbl,eqfilter,desctbl,ctlimittbl,con,cost) 
	if not desctbl then desctbl={m,6} end
	if not eqfilter then eqfilter=Card.IsFaceup end
	local eqfilter2=eqfilter
	eqfilter=function(c,e,tp)
		return c:IsFaceup() and eqfilter2(c,tp)
	end
	local e1=rsef.ACT(cardtbl,nil,desctbl,ctlimittbl,"eq","tg",con,cost,rstg.target({eqfilter,"eq",LOCATION_MZONE,LOCATION_MZONE,1}),rsef.ACT_EQUIP_op)
	local e2=rsef.SV(cardtbl,EFFECT_EQUIP_LIMIT,rsef.ACT_EQUIP_val(eqfilter),nil,nil,nil,"cd")
	return e1,e2
end
function rsef.ACT_EQUIP_op(e,tp,eg,ep,ev,re,r,rp) 
	local tc=rscf.GetTargetCard(Card.IsFaceup)
	if e:GetHandler():IsRelateToEffect(e) and tc then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function rsef.ACT_EQUIP_val(eqfilter) 
	return function(e,c)
		local tp=e:GetHandlerPlayer()
		return eqfilter(c,tp)
	end
end
-----------######Quick Effect Tigger Effect######---------------
--Self Tigger Effect No Force: Base set
function rsef.STO(cardtbl,code,desctbl,ctlimittbl,cate,flag,con,cost,tg,op,resettbl)
	return rsef.Register(cardtbl,EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE,code,desctbl,ctlimittbl,cate,flag,nil,con,cost,tg,op,nil,nil,nil,resettbl)
end 
--Self Tigger Effect Force: Base set
function rsef.STF(cardtbl,code,desctbl,ctlimittbl,cate,flag,con,cost,tg,op,resettbl)
	return rsef.Register(cardtbl,EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE,code,desctbl,ctlimittbl,cate,flag,nil,con,cost,tg,op,nil,nil,nil,resettbl)
end
--Field Tigger Effect No Force: Base set
function rsef.FTO(cardtbl,code,desctbl,ctlimittbl,cate,flag,range,con,cost,tg,op,resettbl)
	return rsef.Register(cardtbl,EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD,code,desctbl,ctlimittbl,cate,flag,range,con,cost,tg,op,nil,nil,nil,resettbl)
end
--Field Tigger Effect Force: Base set
function rsef.FTF(cardtbl,code,desctbl,ctlimittbl,cate,flag,range,con,cost,tg,op,resettbl)
	return rsef.Register(cardtbl,EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD,code,desctbl,ctlimittbl,cate,flag,range,con,cost,tg,op,nil,nil,nil,resettbl)
end
-----------######Quick Effect Ignition Effect######---------------
--Ignition Effect: Base set
function rsef.I(cardtbl,desctbl,ctlimittbl,cate,flag,range,con,cost,tg,op,resettbl)
	return rsef.Register(cardtbl,EFFECT_TYPE_IGNITION,nil,desctbl,ctlimittbl,cate,flag,range,con,cost,tg,op,nil,nil,nil,resettbl)
end
-----------######Quick Effect Quick Effect######---------------
--Quick Effect No Force: Base set
function rsef.QO(cardtbl,code,desctbl,ctlimittbl,cate,flag,range,con,cost,tg,op,timingtbl,resettbl)
	if not code then code=EVENT_FREE_CHAIN end
	if not timingtbl and code==EVENT_FREE_CHAIN then timingtbl={0,TIMINGS_CHECK_MONSTER } end
	return rsef.Register(cardtbl,EFFECT_TYPE_QUICK_O,code,desctbl,ctlimittbl,cate,flag,range,con,cost,tg,op,nil,nil,timingtbl,resettbl)
end 
--Quick Effect Force: Base set
function rsef.QF(cardtbl,code,desctbl,ctlimittbl,cate,flag,range,con,cost,tg,op,resettbl)
	return rsef.Register(cardtbl,EFFECT_TYPE_QUICK_F,code,desctbl,ctlimittbl,cate,flag,range,con,cost,tg,op,nil,nil,nil,resettbl)
end
-------------######Main Quick Effect Set#####-----------------
--Effect: Get default hint string for Duel.Hint ,use in effect target
function rsef.GetDefaultHintString(pcatelist,loc1,loc2,hintstring)
	local hint=0
	if istarget then hint=HINTMSG_TARGET end
	if (loc1 and loc1>0) and (not loc2 or loc2==0) then hint=HINTMSG_SELF end
	if (loc2 and loc2>0) and (not loc1 or loc1==0) then hint=HINTMSG_OPPO end
	local hintlist= { HINTMSG_DESTROY,HINTMSG_RELEASE,HINTMSG_REMOVE,HINTMSG_ATOHAND,HINTMSG_TODECK,
	HINTMSG_TOGRAVE,0,HINTMSG_DISCARD,HINTMSG_SUMMON,HINTMSG_SPSUMMON,
	0,HINTMSG_POSCHANGE,HINTMSG_CONTROL,aux.Stringid(m,1),0,
	0,0,HINTMSG_EQUIP,0,0,
	aux.Stringid(m,2),aux.Stringid(m,2),HINTMSG_FACEUP,0,0, 
	0,HINTMSG_FACEUP,0,0,0,
	HINTMSG_TODECK }
	for k,cate in ipairs(pcatelist) do
		local tf,list=rsof.Table_List(rscate.catelist,cate) 
		if tf then
			local hint2=hintlist[list]
			if hint2>0 then
				hint=hint2
			end 
		end
	end 
	-- destroy and remove 
	if rsof.Table_List(pcatelist,CATEGORY_DESTROY) and
		rsof.Table_List(pcatelist,CATEGORY_REMOVE) then
		hint=HINTMSG_DESTROY 
	end
	-- return to hand
	if rsof.Table_List(pcatelist,CATEGORY_TOHAND) and
		(loc1&LOCATION_ONFIELD ~=0 or loc2&LOCATION_ONFIELD ~=0) then
		hint=HINTMSG_RTOHAND 
	end
	-- return to grave
	if rsof.Table_List(pcatelist,CATEGORY_TOHAND) and
		(loc1&LOCATION_REMOVED  ~=0 or loc2&LOCATION_REMOVED ~=0) then
		hint=aux.Stringid(m,3) 
	end
	if hintstring then 
		hint=hintstring 
	end
	return hint 
end
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
	if getmetatable(tc2)~="Card" then return nil end
	if tc2:IsType(TYPE_MONSTER) then range=LOCATION_MZONE 
	elseif tc2:IsType(TYPE_PENDULUM) then range=LOCATION_PZONE 
	elseif tc2:IsType(TYPE_SPELL+TYPE_TRAP) then range=LOCATION_SZONE
	elseif tc2:IsType(TYPE_FIELD) then range=LOCATION_FZONE  
	end
	if tc2:IsLocation(LOCATION_GRAVE) then range=LOCATION_GRAVE end
	return range 
end
--Effect: Get Flag for SetProperty 
function rsef.GetRegisterProperty(mixflag)
	local flagstringlist={"tg","ptg","de","dsp","dcal","ii","sa","ir","sr","bs","uc","cd","cn","ch","lz","at","sp"}
	return rsof.Mix_Value_To_Table(mixflag,flagstringlist,rsflag.flaglist)
end
rsflag.GetRegisterProperty=rsef.GetRegisterProperty
--Effect: Get Category for SetCategory or SetOperationInfo
function rsef.GetRegisterCategory(mixcategory)
	local catestringlist={"des","res","rm","th","td","tg","disd","dish","sum","sp","tk","pos","con","dis","diss","dr","se","eq","dam","rec","atk","def","ct","coin","dice","lg","lv","neg","an","fus","te"}
	return rsof.Mix_Value_To_Table(mixcategory,catestringlist,rscate.catelist)
end
rscate.GetRegisterCategory=rsef.GetRegisterCategory
--Effect: Register Condition, Cost, Target and Operation 
function rsef.RegisterSolve(e,con,cost,tg,op)
	if con then
		e:SetCondition(con)
	end
	if cost then
		e:SetCost(cost)
	end
	if tg then
		e:SetTarget(tg)
	end
	if op then
		e:SetOperation(op)
	end
end
Effect.RegisterSolve=rsef.RegisterSolve
--Effect: Register Effect Attributes
function rsef.Register(cardtbl,effecttype,effectcode,desctbl,ctlimittbl,cate,flag,range,con,cost,tg,op,val,tgrangetbl,timingtbl,resettbl)
	local tc1,val2,ignore=rsef.GetRegisterCard(cardtbl)
	local e=Effect.CreateEffect(tc1)
	if effecttype then
		e:SetType(effecttype)
	end
	if effectcode then
		e:SetCode(effectcode)
	end
	if desctbl then
		if type(desctbl)=="table" then
			e:SetDescription(aux.Stringid(desctbl[1],desctbl[2]))
		else
			e:SetDescription(desctbl)
		end
	end
	if ctlimittbl then
		local limitcount,limitcode=0,0
		if type(ctlimittbl)=="table" then
			if #ctlimittbl==1 then
				if ctlimittbl[1]<=100 then
					limitcount=ctlimittbl[1]
				else
					limitcount=1
					limitcode=ctlimittbl[1]
				end
			elseif #ctlimittbl==2 then
				limitcount=ctlimittbl[1]
				if value==3 or value==0x1 then
					limitcode=EFFECT_COUNT_CODE_SINGLE 
				else
					limitcode=ctlimittbl[2]
				end
			elseif #ctlimittbl==3 then
				limitcount=ctlimittbl[1]
				limitcode=ctlimittbl[2]
				local value=ctlimittbl[3]
				if value==1 then 
					limitcode=limitcode+EFFECT_COUNT_CODE_OATH 
				elseif value==2 then
					limitcode=limitcode+EFFECT_COUNT_CODE_DUEL 
				else 
					limitcode=limitcode+value
				end
			end
		else
			if limitcount<=100 then
				limitcount=ctlimittbl
			else
				limitcount=1
				limitcode=ctlimittbl
			end
		end
		e:SetCountLimit(limitcount,limitcode)
	end
	if cate then
		local cate2=rsef.GetRegisterCategory(cate)
		if cate2>0 then
			e:SetCategory(cate2) 
		end
	end
	if flag then
		local flag2=rsef.GetRegisterProperty(flag)
		if flag2>0 then
			e:SetProperty(flag2) 
		end
	end
	if range then
		e:SetRange(range)
	end
	rsef.RegisterSolve(e,con,cost,tg,op)
	if val then
		e:SetValue(val)
	end
	if tgrangetbl then
		if type(tgrangetbl)=="table" then
			if #tgrangetbl==1 then
				e:SetTargetRange(tgrangetbl[1],tgrangetbl[1]) 
			else
				e:SetTargetRange(tgrangetbl[1],tgrangetbl[2])
			end
		else
			e:SetTargetRange(tgrangetbl) 
		end
	end
	if timingtbl then
		if type(timingtbl)=="table" then
			if #timingtbl==1 then
				e:SetHintTiming(timingtbl[1]) 
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
				e:SetReset(resettbl[1]) 
			else
				e:SetReset(resettbl[1],resettbl[2])
			end
		else
			e:SetReset(resettbl) 
		end
	end
	if type(val2)=="number" and (val2==0 or val2==1) then
		Duel.RegisterEffect(e,val2)
	else
		val2:RegisterEffect(e,ignore)
	end
	local fid=e:GetFieldID()
	return e,fid
end
-------------#######Summon Function#########-----------------
--Summon Function: Quick Special Summon buff
--valtbl:{atk,def,lv} 
--waytbl:{way,resettbl} 
function rssf.SummonBuff(valtbl,dis,trigger,leaveloc,waytbl)
	return function(c,sc,e,tp,sg)
		local reset=((c==sc and not sg or #sg==1) and  rsreset.est_d or rsreset.est)
		if valtbl then
			local atk,def,lv=valtbl[1],valtbl[2],valtbl[3]
			rsef.SV_SET({c,sc,true},"atk,def",{atk,def},nil,reset)
			rsef.SV_CHANGE({c,sc,true},"lv",lv,nil,reset)
		end
		if dis then
			rsef.SV_LIMIT({c,sc,true},"dis,dise",nil,nil,reset)
		end
		if trigger then
			rsef.SV_LIMIT({c,tc,true},"tri",nil,nil,reset)
		end
		if type(leaveloc)=="number" then
			local flag=nil
			if c==sc then flag=EFFECT_CANNOT_DISABLE end
			rsef.SV_REDIRECT({c,sc,true},"leave",leaveloc,nil,rsreset.ered,flag)
		end
		if waytbl then
			if type(waytbl)=="string" then waytbl={waytbl} end
			if type(waytbl)=="boolean" then waytbl={"des"} end
			local way=waytbl[1]
			local resettbl=waytbl[2]
			if not resettbl then resettbl={0,1} end
			local reset2,resetct,resetplayer=resettbl[1],resettbl[2],resettbl[3]
			local fid=c:GetFieldID()
			for tc in aux.Next(sg) do
				tc:RegisterFlagEffect(c:GetOriginalCode(),rsreset.est+reset2,0,resetct,fid)
			end  
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END) 
			e1:SetCountLimit(1)
			if reset2 and reset2~=0 then
				e1:SetReset(reset2,resetct)
			end
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			sg:KeepAlive()
			e1:SetLabelObject(sg)
			e1:SetCondition(rssf.SummonBuff_Con(fid,resetct,resetplayer))
			e1:SetOperation(rssf.SummonBuff_Op(fid,way))
			Duel.RegisterEffect(e1,tp)   
		end
	end
end
function rssf.SummonBuff_Filter(c,e,fid)
	return c:GetFlagEffectLabel(e:GetOwner():GetOriginalCode())==fid
end 
function rssf.SummonBuff_Con(fid,resetct,resetplayer)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local g=e:GetLabelObject()
		local rg=g:Filter(rssf.SummonBuff_Filter,nil,e,fid)
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
function rssf.SummonBuff_Op(fid,way)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetOwner()
		Duel.Hint(HINT_CARD,0,c:GetOriginalCode())
		local g=e:GetLabelObject()
		local rg=g:Filter(rssf.SummonBuff_Filter,nil,e,fid)
		if way=="des" then Duel.Destroy(rg,REASON_EFFECT)
		elseif way=="th" then Duel.SendtoHand(rg,nil,REASON_EFFECT)
		elseif way=="td" then Duel.SendtoDeck(rg,nil,2,REASON_EFFECT)
		elseif way=="tdt" then Duel.SendtoDeck(rg,nil,0,REASON_EFFECT)
		elseif way=="tdb" then Duel.SendtoDeck(rg,nil,1,REASON_EFFECT)
		elseif way=="rm" then Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
		elseif way=="rg" then Duel.SendtoGrave(rg,REASON_EFFECT)
		end
		if g:FilterCount(rssf.SummonBuff_Filter,nil,e,fid)<=0 then
			g:DeleteGroup()
			e:Reset()
		end
	end
end 
--Summon Function: Duel.SpecialSummon + buff
function rssf.SpecialSummon(ssgorc,sstype,ssplayer,tplayer,ignorecon,ignorerevie,pos,zone,sumfun)
	sstype,ssplayer,tplayer,ignorecon,ignorerevie,pos=rssf.GetSSDefaultParameter(sstype,ssplayer,tplayer,ignorecon,ignorerevie,pos)
	local ct=0
	if zone then
		ct=Duel.SpecialSummon(ssgorc,sstype,ssplayer,tplayer,ignorecon,ignorerevie,pos,zone)
	else
		ct=Duel.SpecialSummon(ssgorc,sstype,ssplayer,tplayer,ignorecon,ignorerevie,pos)
	end
	local g=Duel.GetOperatedGroup()
	if #g>0 and sumfun then
		local c=g:GetFirst():GetReasonEffect():GetHandler()
		for tc in aux.Next(g) do
			sumfun(c,tc,e,tp,g)
		end
	end 
	return ct,g 
end 
--Summon Function: Duel.SpecialSummonStep + buff 
function rssf.SpecialSummonStep(sscard,sstype,ssplayer,tplayer,ignorecon,ignorerevie,pos,zone,sumfun) 
	sstype,ssplayer,tplayer,ignorecon,ignorerevie,pos=rssf.GetSSDefaultParameter(sstype,ssplayer,tplayer,ignorecon,ignorerevie,pos)
	local tf=false
	if zone then
		tf=Duel.SpecialSummonStep(sscard,sstype,ssplayer,tplayer,ignorecon,ignorerevie,pos,zone)
	else
		tf=Duel.SpecialSummonStep(sscard,sstype,ssplayer,tplayer,ignorecon,ignorerevie,pos)
	end
	if tf and sumfun then
		local c=sscard:GetReasonEffect():GetHandler()
		sumfun(c,sscard,e,tp)
	end
	return tf,sscard
end
--Summon Function: Duel.SpecialSummon to either player's field + buff
function rssf.SpecialSummonEither(ssgorc,e,sstype,ssplayer,tplayer,ignorecon,ignorerevie,pos,zone2,sumfun) 
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
		if rssf.SpecialSummonStep(sscard,sstype,ssplayer,sump,ignorecon,ignorerevie,pos,sel_zone,sumfun) then
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
--value: SummonConditionValue - can only be special summoned by self effects
function rsval.spcons(e,se,sp,st)
	return se:GetHandler()==e:GetHandler() and not se:IsHasProperty(EFFECT_FLAG_UNCOPYABLE)
end
--value: reason by battle or card effects
function rsval.indbae(string1,string2)
	return function(e,re,r,rp)
		if not string1 and not string2 then return r&REASON_BATTLE+REASON_EFFECT ~=0 end
		return ((string1=="battle" or string2=="battle") and r&REASON_BATTLE ~=0 ) or ((string1=="effect" or string2=="effect") and r&REASON_EFFECT ~=0 )
	end
end
--value: reason by battle or card effects, EFFECT_INDESTRUCTABLE_COUNT
function rsval.indct(string1,string2)
	return function(e,re,r,rp)
		if ((string1=="battle" or string2=="battle") and r&REASON_BATTLE ~=0 ) or ((string1=="effect" or string2=="effect") and r&REASON_EFFECT ~=0 ) or (not string1 and not string2 and r&REASON_BATTLE+REASON_EFFECT ~=0) then
			return 1
		else return 0 
		end
	end
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
function rsval.imntg1(e,re)
	local c=e:GetHandler()
	local ec=re:GetHandler()
	if re:GetOwner()==e:GetOwner() or ec:IsHasCardTarget(c) or (re:IsHasType(EFFECT_TYPE_ACTIONS) and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and c:IsRelateToEffect(re)) then return false
	end
	return true
end
--value: unaffected by opponent's card effects that do not target it
function rsval.imntg2(e,re)
	local c=e:GetHandler()
	local ec=re:GetHandler()
	if re:GetHandlerPlayer()==e:GetHandlerPlayer() or ec:IsHasCardTarget(c) or (re:IsHasType(EFFECT_TYPE_ACTIONS) and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and c:IsRelateToEffect(re)) then return false
	end
	return true
end
-------------#########Quick Target###########-----------------
--Card target: do not have an effect target it
function rstg.neftg(e,c)
	local te,g=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TARGET_CARDS)
	return not te or not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) or not g or not g:IsContains(c)
end 
--Target function: Get except group 
rsgf.GetExceptGroup=rstg.GetExceptGroup 
function rstg.GetExceptGroup(e,tp,eg,ep,ev,re,r,rp,exceptfun)
	local c=e:GetHandler()
	local excepttype=aux.GetValueType(exceptfun)
	local exceptg=Group.CreateGroup()
	if excepttype=="Card" then exceptg:AddCard(exceptfun)
	elseif excepttype=="Group" then exceptg:Merge(exceptfun)
	elseif excepttype=="boolean" then
		if excepttype then exceptg:AddCard(c) end
	elseif excepttype=="function" then
		exceptg=excepttype(e,tp,eg,ep,ev,re,r,rp)
	end
	return exceptg,#exceptg
end
--Target function: Get target attributes
function rstg.GetTargetAttribute(targetlist)
	if not targetlist then return 0,0,0,0,nil end
	local ffunction=targetlist[1]
	if not ffunction then ffunction=aux.TRUE end
	local catevalue=targetlist[2]
	local _,catelist=rsef.GetRegisterCategory(catevalue)
	local loc1,loc2=targetlist[3],targetlist[4]
	local minct,maxct=targetlist[5],targetlist[6]
	if not minct then minct=0 end
	if not maxct then maxct=minct end 
	local exceptfun=targetlist[7]
	local selecthint=targetlist[8]
	if not loc1 then loc1=0 end
	if not loc2 then loc2=0 end 
	return ffunction,catelist,loc1,loc2,minct,maxct,exceptfun,selecthint
end
--Effect target: Target Cards Main Set
--targetlist= {targetvalue1,targetvalue2,...}
--targetvalue1={ffunction,category,loc1,loc2,minct,maxct,exceptfun,selecthint}
function rstg.target(...)
	local targetlist={...}
	return function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chkc or chk==0 then 
			return rstg.TargetCheck(e,tp,eg,ep,ev,re,r,rp,chk,chkc,table.unpack(targetlist)) 
		end
		rstg.TargetSelect(e,tp,eg,ep,ev,re,r,rp,table.unpack(targetlist))
	end
end
--Effect target: Check chkc & chk
function rstg.TargetCheck(e,tp,eg,ep,ev,re,r,rp,chk,chkc,valuetype,...)
	local targetlist={}
	if type(valuetype)=="table" then 
		targetlist={valuetype,...}
	else 
		targetlist={{valuetype,...}}
	end
	local c=e:GetHandler()
	local ffunction,catelist,loc1,loc2,minct,maxct,exceptfun,selecthint = rstg.GetTargetAttribute(targetlist[1])
	local exceptg=rstg.GetExceptGroup(e,tp,eg,ep,ev,re,r,rp,exceptfun)
	if chkc then
		if #targetlist>1 then return false end
		if minct>1 then return false end
		if not chkc:IsLocation(loc1+loc2) then return false end 
		if loc1==0 and loc2>0 and chkc:IsControler(tp) then return false end
		if loc2==0 and loc1>0 and chkc:IsControler(1-tp) then return false end
		if #exceptg>0 and exceptg:IsContains(chkc) then return false end
		if ffunction and not ffunction(chkc,e,tp,eg,ep,ev,re,r,rp) then  return false end
		return true
	end 
	if chk==0 then 
		if e:IsHasType(EFFECT_TYPE_TRIGGER_F) or e:IsHasType(EFFECT_TYPE_QUICK_F) then return true end
		local usingg=Group.CreateGroup()
		return Duel.IsExistingTarget(rstg.TargetFilter,tp,loc1,loc2,minct,exceptg,e,tp,eg,ep,ev,re,r,rp,usingg,table.unpack(targetlist))
	end
end
--Effect target: Select targets
function rstg.TargetSelect(e,tp,eg,ep,ev,re,r,rp,valuetype,...)
	local targetlist={}
	if type(valuetype)=="table" then 
		targetlist={valuetype,...}
	else
		targetlist={{valuetype,...}}
	end 
	local categroup={}
	for i=1,#targetlist do
		local targetlistfollow={}
		local usingg=Group.CreateGroup()
		for k,targetvalue in pairs(targetlist) do
			if k>i then table.insert(targetlistfollow,targetvalue) end
		end 
		local ffunction,catelist,loc1,loc2,minct,maxct,exceptfun,selecthint = rstg.GetTargetAttribute(targetlist[i])
		local exceptg=rstg.GetExceptGroup(e,tp,eg,ep,ev,re,r,rp,exceptfun)
		local hint=rsef.GetDefaultHintString(catelist,loc1,loc2,selecthint)
		Duel.Hint(HINT_SELECTMSG,tp,hint)
		local g=Duel.SelectTarget(tp,rstg.TargetFilter,tp,loc1,loc2,minct,maxct,exceptg,e,tp,eg,ep,ev,re,r,rp,usingg,targetlist[i],table.unpack(targetlistfollow))
		usingg:Merge(g)
		exceptg:Merge(usingg)
		for _,cate in ipairs(catelist) do
			if not categroup[cate] then
				categroup[cate]=Group.CreateGroup()
			end
			categroup[cate]:Merge(g)
		end
	end
	for _,cate in ipairs(rscate.catelist) do 
		if categroup[cate] then 
			Duel.SetOperationInfo(0,cate,categroup[cate],#categroup[cate],0,0)
		end
	end
end
--Effect target: Target filter
function rstg.TargetFilter(c,e,tp,eg,ep,ev,re,r,rp,usingg,targetvalue1,targetvalue2,...)
	local usingg2=usingg:Clone() 
	usingg2:AddCard(c)
	if targetvalue1 then
		local ffunction,catelist,loc1,loc2,minct,maxct,exceptfun,selecthint = rstg.GetTargetAttribute(targetvalue1)
		if ffunction and not ffunction(c,e,tp,eg,ep,ev,re,r,rp) then return false end
	end 
	if targetvalue2 then
		local ffunction,catelist,loc1,loc2,minct,maxct,exceptfun,selecthint = rstg.GetTargetAttribute(targetvalue2)
		local exceptg=rstg.GetExceptGroup(e,tp,eg,ep,ev,re,r,rp,exceptfun)
		exceptg:Merge(usingg2)
		return Duel.IsExistingTarget(rstg.TargetFilter,tp,loc1,loc2,minct,exceptg,e,tp,eg,ep,ev,re,r,rp,usingg2,targetvalue2,...)
	end
	return true
end
-------------#########Quick Cost###########-----------------
--cost: remove overlay card form self
function rscost.rmxyzs(...)
	local list={...}
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		 local c=e:GetHandler()
		 local ct1,ct2,issetlabel=0,0,false
		 if #list==0 then 
			ct1=c:GetOverlayCount() 
			ct2=ct1 
		 end
		 if #list==1 then
			if type(list[1])=="number" then
				ct1=list[1]
				ct2=ct1
			elseif type(list[1])=="boolean" then
				ct1=c:GetOverlayCount() 
				ct2=ct1 
				issetlabel=list[1]
			end
		 end
		 if #list==2 then
			if type(list[1])=="number" then
				ct1=list[1]
			end
			if type(list[2])=="number" then
				ct2=list[2]
			end
			if type(list[2])=="boolean" then
				issetlabel=list[2]
			end
		 end
		 if #list==3 then
			ct1,ct2,issetlabel=list[1],list[2],list[3]
		 end
		 if chk==0 then return c:CheckRemoveOverlayCard(tp,ct1,REASON_COST) end
		 c:RemoveOverlayCard(tp,ct1,ct2,REASON_COST)
		 local rct=Duel.GetOperatedGroup():GetCount()
		 if issetlabel then
			e:SetLabel(rct)
		 end
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
function rscon.phmp(e)
	local phase=Duel.GetCurrentPhase()
	return phase==PHASE_MAIN1 or phase==PHASE_MAIN2 
end 
--Condition: Phase no damage calculate 
function rscon.phndam(e)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
--Condition: Phase damage calculate 
function rscon.phdam(e)
	return Duel.GetCurrentPhase()==PHASE_DAMAGE and not Duel.IsDamageCalculated()
end
--Condition in ADV or SP Summon Sucess
function rscon.sumtype(sumtbl,sumfilter)
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
		if sumfilter then
			if not re or not sumfilter(re:GetHandler(),re) then return false end
		end
		return true 
	end
end 
function rscon.negcon(filterfun)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
		local seq=nil
		if loc&LOCATION_MZONE ~=0 or loc&LOCATION_SZONE ~=0 then
			seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_SEQUENCE)
		end
		local tg=nil
		if re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
			tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
		end
		if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
		if filterfun and not filterfun(tp,re,rp,tg,loc,seq) then return false end
		return Duel.IsChainNegatable(ev)
	end
end
-------------#########Zone&Sequence Function#####-----------------
--get excatly colomn zone, import the seq
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
	if loc==LOCATION_SZONE and seq>4 then 
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
function rsgf.GetTargetGroup(targetfilter)
	local g,e,tp=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	local f=function(c,fe,fp,rfilter)
		if not c:IsRelateToEffect(fe) then return false end
		if rfilter and not rfilter(c,fe,fp) then return false end
		return true
	end
	local tg=g:Filter(f,nil,e,tp,targetfilter)
	return tg,tg:GetFirst()
end
-------------###########Card Function#########-----------------
--Card effect:Auxiliary.ExceptThisCard + Card.IsFaceup()
function rscf.GetRelationCard(e)
	if not e then e=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_EFFECT) end
	local c=aux.ExceptThisCard(e)
	if c and c:IsFaceup() then return c 
	else return nil
	end
end
--Card/Summon effect: Set Special Summon Produce
function rscf.SetSpecialSummonProduce(cardtbl,range,con,op,desctbl,ctlimittbl,resettbl)
	local tc1,tc2,ignore=rsef.GetRegisterCard(cardtbl)
	if not desctbl then desctbl={m,4} end
	local flag="uc" 
	if not tc2:IsSummonableCard() then flag="uc,cd" end
	local e1=rsef.Register(cardtbl,EFFECT_TYPE_FIELD,EFFECT_SPSUMMON_PROC,desctbl,ctlimittbl,nil,flag,range,con,nil,nil,op,nil,nil,nil,resettbl)
	return e1
end
rssf.SetSpecialSummonProduce=rscf.SetSpecialSummonProduce
--Card/Summon effect: Is monster can normal or special summon
function rscf.SetSummonCondition(cardtbl,isnsable,sumvalue,resettbl)
	local tc1,tc2,ignore=rsef.GetRegisterCard(cardtbl)
	if not isnsable then
		tc2:EnableReviveLimit()
	end
	if not sumvalue then sumvalue=aux.FALSE end
	local e1=rsef.SV(cardtbl,EFFECT_SPSUMMON_CONDITION,sumvalue,nil,nil,resettbl,"uc,cd")
	return e1
end 
rssf.SetSummonCondition=rscf.SetSummonCondition
--Check Built-in SetCode / Series Main Set
function rscf.CheckSetCardMainSet(c,settype,series1,...) 
	local stringlist=rsof.String_To_Table({series1,...})
	local codelist={}
	if settype=="base" then
		codelist={c:GetCode()}
	elseif settype=="fus" then
		codelist={c:GetFusionCode()}
	elseif settype=="link" then
		codelist={c:GetLinkCode()}
	end
	for _,code in ipairs(codelist) do 
		local mt=_G["c"..code]
		if not mt and not mt.rssetcode then
			if pcall(function() dofile("expansions/script/c"..code..".lua") end) or pcall(function() dofile("script/c"..code..".lua") end) then
				mt=_G["c"..code]
			end
		end
		if mt and mt.rssetcode then
			local setcodelist=rsof.String_To_Table(mt.rssetcode)
			for _,string in pairs(stringlist) do 
				for _,setcode in pairs(setcodelist) do
					local setcodelist2=rsof.String_Split(setcode, '_')
					if rsof.Table_List(setcodelist2,string) then return true end
				end
			end
		end
	end
	return false 
end 
--Check Built-in Base SetCode / Series
function rscf.CheckSetCard(c,series1,...) 
	return rscf.CheckSetCardMainSet(c,"base",series1,...) 
end
Card.CheckSetCard=rscf.CheckSetCard
--Check Built-in Fusion SetCode / Series
function rscf.CheckFusionSetCard(c,series1,...) 
	return rscf.CheckSetCardMainSet(c,"fus",series1,...) 
end
Card.CheckFusionSetCard=rscf.CheckFusionSetCard
--Check Built-in Link SetCode / Series
function rscf.CheckLinkSetCard(c,series1,...) 
	return rscf.CheckSetCardMainSet(c,"link",series1,...) 
end
Card.CheckLinkSetCard=rscf.CheckLinkSetCard
--Card/Summon effect: Set Other Link Materials
function rscf.SetExtraLinkMaterial(c,materialfilter,loc1,loc2)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	if not materialfilter then materialfilter=aux.TRUE end
	if not loc1 then loc1=0 end
	if not loc2 then loc2=LOCATION_MZONE end
	local ff=function(mc,lc,ffilter)
		return not ffilter or ffilter(mc,lc)
	end
	local matfun=function(lc)
		return Duel.GetMatchingGroup(ff,lc:GetControler(),loc1,loc2,nil,lc,materialfilter)
	end
	local mt=getmetatable(c) 
	mt.rslinkmatfun=matfun
	if rscf.SetExtraLinkMaterial_Switch then return end
	rscf.SetExtraLinkMaterial_Switch=true
	local f1=aux.GetLinkMaterials
	local f2=aux.LCheckOtherMaterial
	aux.GetLinkMaterials=function(tp,f,lc)
		local mg1=f1(tp,f,lc)
		local f3=lc.rslinkmatfun
		if f3 then
			local f4=function(mc,mf,mlc)
				if mc:IsLocation(LOCATION_ONFIELD) and not mc:IsFaceup() then return false end
				return mc:IsCanBeLinkMaterial(mlc) and (not mf or mf(mc))
			end
			local mg2=f3(lc)
			mg2=mg2:Filter(f4,nil,f,lc)
			if #mg2>0 then mg1:Merge(mg2) end
		end
		return mg1
	end
	aux.LCheckOtherMaterial=function(c,mg,lc)
		local le={c:IsHasEffect(EFFECT_EXTRA_LINK_MATERIAL)}
		if #le==0 then return true end
		for _,te in pairs(le) do
			local f=te:GetValue()
			if not f or f(te,lc,mg) then return true end
		end
		return false
	end
end 
rssf.SetExtraLinkMaterial=rscf.SetExtraLinkMaterial
--Card/Summon effect: no level monster Synchro Summon Produce
function rscf.SetNoLevelSynchro(c,lv)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	local mt=getmetatable(c)
	mt.rsnlsynlv=lv
	if rscf.SetNoLevelSynchro_Switch then return end
	rscf.SetNoLevelSynchro_Switch=true
	local f=aux.SynMixCheckGoal
	aux.SynMixCheckGoal=function(tp,sg,minc,ct,syncard,sg1,smat,gc)
		local f2=Card.GetLevel
		Card.GetLevel=function(sc)
			if sc.rsnlsynlv then return sc.rsnlsynlv
			else return f2(sc)
			end
		end
		local bool=f(tp,sg,minc,ct,syncard,sg1,smat,gc)
		Card.GetLevel=f
		return bool
	end
end
rssf.SetNoLevelSynchro=rscf.SetNoLevelSynchro
--Card/Summon effect: Ladian's Synchro Summon (treat tuner as another lv) --BUG, lan de xiu fu
function rscf.SetTunerChangeLevelSynchro(c,lv,force)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	local mt=getmetatable(c)
	mt.rstcsynlv=lv
	if not force then force=false end
	mt.rstcsynforce=force
	if rscf.SetTunerChangeLevelSynchro_Switch then return end
	rscf.SetTunerChangeLevelSynchro_Switch=true
	local ff=aux.SynMixFilter4
	aux.SynMixFilter4=function(mc,fun,minc,maxc,syncard,matg,smat,c1,c2,c3,gc)
		if syncard.rstcsynlv then
			local msct=getmetatable(syncard)
			msct.rstcsynmat=c1
		end
		return ff(mc,fun,minc,maxc,syncard,matg,smat,c1,c2,c3,gc)
	end
	local fc=aux.SynMixCheckGoal
	aux.SynMixCheckGoal=function(tp,sg,minc,ct,syncard,sg1,smat,gc)
		if not force and fc(tp,sg,minc,ct,syncard,sg1,smat,gc) then return true end
		local force2=syncard.rstcsynforce
		local fs=Card.GetSynchroLevel
		if force2 then
			Card.GetSynchroLevel=function(matc,syncard2)
				if syncard2.rstcsynmat==matc then
					return syncard2.rstcsynlv
				else
					return fs(matc,syncard2)
				end
			end
		else
			Card.GetSynchroLevel=function(matc,syncard2)
				if syncard2.rstcsynmat==matc then
					return syncard2.rstcsynlv*65536+matc:GetLevel()
				else
					return fs(matc,syncard2)
				end
			end
		end
		local bool=fc(tp,sg,minc,ct,syncard,sg1,smat,gc)
		Card.GetSynchroLevel=fs
		return bool
	end
end
rssf.SetTunerChangeLevelSynchro=rscf.SetTunerChangeLevelSynchro
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
function rscf.GetTargetCard(targetfilter)
	local tc=Duel.GetFirstTarget()
	if not tc then return nil end
	local e,tp=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER) 
	if not tc:IsRelateToEffect(e) then return nil end
	if targetfilter and not targetfilter(tc,e,tp) then return nil end
	return tc
end 
-------------#########RSV Other Function#######-----------------
--split the string, ues "," as delimiter
function rsof.String_Split(stringinput,delimiter)  
	if not delimiter then delimiter=',' end
	local pos,arr = 0, {}  
	if delimiter~='_' then
		for st,sp in function() return string.find(stringinput, delimiter, pos, true) end do  
			table.insert(arr, string.sub(stringinput, pos, st - 1))  
			pos = sp + 1  
		end  
		table.insert(arr, string.sub(stringinput, pos)) 
		return arr
	else
		for st,sp in function() return string.find(stringinput, delimiter, pos, true) end do  
			table.insert(arr, string.sub(stringinput, pos, st - 1))  
			pos = sp + 1  
		end  
		table.insert(arr, string.sub(stringinput, pos)) 
		local arr2={}
		local string2=arr[1]
		for k,v in ipairs(arr) do 
			if k==1 then table.insert(arr2, string2) 
			else
				string2=string2 .. "_" .. v
				table.insert(arr2, string2)
			end
		end
		return arr2
	end 
end  
--Sting to Table (for different formats)
--you can use "a,b,c" or {"a,b,c"} or {"a","b","c"} as same
--return {"a","b","c"}
function rsof.String_To_Table(value)
	local table1={}
	if type(value)=="string" then
		table1=rsof.String_Split(value)
	elseif type(value)=="table" then
		for _,v in ipairs(value) do
			local table2=rsof.String_Split(v)
			for _,v2 in ipairs(table2) do
				table.insert(table1,v2) 
			end
		end
	end
	return table1
end
--suit 2 tables (for rsv_E_SV)
function rsof.Table_Suit(value1,value2,value3,value4)
	local table1=rsof.String_To_Table(value1)
	local table2=rsof.String_To_Table(value2)
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
--Other function: make mix type valuelist1 (can be string, table or string+table) become int table, string will be suitted with valuelistall and stringlistall to index the correct int 
function rsof.Mix_Value_To_Table(valuelist1,stringlistindex,valuelistindex)
	if type(valuelist1)~="table" then
		valuelist1={valuelist1}
	end
	local value=0
	local valuelist2={}
	local stringlist={}
	for k,v in pairs(valuelist1) do
		if type(v)=="number" then 
			value=value+v
			table.insert(valuelist2,value)
		elseif type(v)=="string" and not rsof.Table_List(stringlist,v) then
			table.insert(stringlist,v)
		end
	end
	local valuenumlist=rsof.Table_Suit(stringlist,stringlistindex,valuelistindex) 
	for _,value2 in ipairs(valuenumlist) do
		if value&value2==0 then
			value=value+value2
			table.insert(valuelist2,value2)
		end
	end
	return value,valuelist2
end
--other function: N effects select 1
function rsof.SelectOption(p,...)
	local functionlist={...}
	local off=1
	local ops={}
	local opval={}
	for k,v in ipairs(functionlist) do
		if type(v)=="boolean" and v and k~=#functionlist then
			local selecthint=functionlist[k+1]
			if type(selecthint)=="table" then ops[off]=aux.Stringid(selecthint[1],selecthint[2])
			else
				ops[off]=selecthint
			end
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