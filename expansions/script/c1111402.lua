--灵纹·星辉下的起舞
local m=1111402
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
cm.named_with_Lines=true
--
function c1111402.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c1111402.tg1)
	e1:SetOperation(c1111402.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetValue(c1111402.limit2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetCountLimit(1)
	e3:SetTarget(c1111402.tg3)
	e3:SetOperation(c1111402.op3)
	c:RegisterEffect(e3)
--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_EQUIP)
	e4:SetRange(LOCATION_SZONE)
	e4:SetOperation(c1111402.op4)
	c:RegisterEffect(e4)
--
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TODECK)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetOperation(c1111402.op5)
	c:RegisterEffect(e5)
--
	if not c1111402.global_check then
		c1111402.global_check=true
		muxu11402_GetLevel={}
		muxu11402_GetLevel[1]=0
	end
--
end
--
function c1111402.tfilter1(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)~=0
end
function c1111402.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c1111402.tfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1111402.tfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c1111402.tfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,c,1,0,0)
end
--
function c1111402.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) then return end
	if not tc:IsRelateToEffect(e) then return end
	if tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
--
function c1111402.limit2(e,c)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)~=0
end
--
function c1111402.tfilter3(c,e)
	return c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end
function c1111402.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local p=c:GetEquipTarget():GetControler()
	if chk==0 then return c:GetEquipTarget():IsReason(REASON_EFFECT+REASON_BATTLE) and Duel.IsExistingMatchingCard(c1111402.tfilter3,tp,LOCATION_ONFIELD,0,1,nil,e) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		local g=Duel.SelectMatchingCard(tp,c1111402.tfilter3,p,LOCATION_ONFIELD,0,1,1,nil,e)
		local tc=g:GetFirst()
		e:SetLabelObject(tc)
		tc:SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	else return false end
end
--
function c1111402.op3(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	tc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.Destroy(tc,REASON_EFFECT+REASON_REPLACE)
end
--
function c1111402.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if eg:GetFirst()~=c then return end
	local tc=c:GetEquipTarget()
	if not tc then return end
	if tc:IsRace(RACE_FAIRY) then
		local e4_1=Effect.CreateEffect(c)
		e4_1:SetDescription(aux.Stringid(1111402,0))
		e4_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e4_1:SetType(EFFECT_TYPE_FIELD)
		e4_1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e4_1:SetRange(LOCATION_SZONE)
		e4_1:SetLabelObject(tc)
		e4_1:SetTargetRange(0,1)
		e4_1:SetCondition(c1111402.con4_1)
		e4_1:SetTarget(c1111402.limit4_1)
		e4_1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e4_1)
	end
	if tc:IsRace(RACE_SPELLCASTER) then
		local e4_2=Effect.CreateEffect(c)
		e4_2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e4_2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4_2:SetCode(EVENT_ADJUST)
		e4_2:SetRange(LOCATION_SZONE)
		e4_2:SetLabelObject(tc)
		e4_2:SetCondition(c1111402.con4_1)
		e4_2:SetOperation(c1111402.op4_2)
		c:RegisterEffect(e4_2)
		local e4_3=Effect.CreateEffect(c)
		e4_3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4_3:SetCode(EVENT_PHASE+PHASE_END)
		e4_3:SetRange(LOCATION_SZONE)
		e4_3:SetCountLimit(1)
		e4_3:SetLabelObject(tc)
		e4_3:SetCondition(c1111402.con4_1)
		e4_3:SetOperation(c1111402.op4_3)
		c:RegisterEffect(e4_3)
	end
end
--
function c1111402.con4_1(e)
	local tc=e:GetHandler():GetEquipTarget()
	if tc==e:GetLabelObject() then
		return true
	else return false end
end
--
function c1111402.lfilter4_1(c)
	return c:IsFaceup() and c:GetLevel()>0
end
function c1111402.limit4_1(e,c,sump,sumtype,sumpos,targetp)
	local p=e:GetHandler():GetControler()
	local sg=Duel.GetMatchingGroup(c1111402.lfilter4_1,p,0,LOCATION_MZONE,nil)
	if sg:GetCount()<1 then return false end
	muxu11402_GetLevel={}
	muxu11402_GetLevel[1]=0
	local sc=sg:GetFirst()
	while sc do
		muxu11402_GetLevel[#muxu11402_GetLevel+1]=sc:GetLevel()
		sc=sg:GetNext()
	end
	local checknum=0
	for k,v in ipairs(muxu11402_GetLevel) do
		if v==c:GetLevel() then checknum=1 end
	end
	return checknum==1 and c:GetLevel()>0 and not c:IsLocation(LOCATION_HAND)
end
--
function c1111402.ofilter4_2_1(c)
	return c:IsFaceup() and c:IsType(TYPE_RITUAL)
end
function c1111402.ofilter4_2_3(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO)
end
function c1111402.ofilter4_2_5(c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION)
end
function c1111402.ofilter4_2_7(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c1111402.ofilter4_2_9(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function c1111402.op4_2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	local gn=Group.CreateGroup()
	local g1=Duel.GetMatchingGroup(c1111402.ofilter4_2_1,tp,LOCATION_MZONE,0,nil)
	local g2=Duel.GetMatchingGroup(c1111402.ofilter4_2_1,tp,0,LOCATION_MZONE,nil)
	local g3=Duel.GetMatchingGroup(c1111402.ofilter4_2_3,tp,LOCATION_MZONE,0,nil)
	local g4=Duel.GetMatchingGroup(c1111402.ofilter4_2_3,tp,0,LOCATION_MZONE,nil)
	local g5=Duel.GetMatchingGroup(c1111402.ofilter4_2_5,tp,LOCATION_MZONE,0,nil)
	local g6=Duel.GetMatchingGroup(c1111402.ofilter4_2_5,tp,0,LOCATION_MZONE,nil)
	local g7=Duel.GetMatchingGroup(c1111402.ofilter4_2_7,tp,LOCATION_MZONE,0,nil)
	local g8=Duel.GetMatchingGroup(c1111402.ofilter4_2_7,tp,0,LOCATION_MZONE,nil)
	local g9=Duel.GetMatchingGroup(c1111402.ofilter4_2_9,tp,LOCATION_MZONE,0,nil)
	local g10=Duel.GetMatchingGroup(c1111402.ofilter4_2_9,tp,0,LOCATION_MZONE,nil)
	if g1:GetCount()>1 then
		local num=g1:GetCount()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg1=g1:Select(tp,num-1,num-1,nil)
		gn:Merge(sg1)
		g3:Sub(sg1)
		g5:Sub(sg1)
		g7:Sub(sg1)
		g9:Sub(sg1)
	end
	if g2:GetCount()>1 then
		local num=g2:GetCount()
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local sg2=g2:Select(1-tp,num-1,num-1,nil)
		gn:Merge(sg2)
		g4:Sub(sg2)
		g6:Sub(sg2)
		g8:Sub(sg2)
		g10:Sub(sg2)
	end
	if g3:GetCount()>1 then
		local num=g3:GetCount()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg3=g3:Select(tp,num-1,num-1,nil)
		gn:Merge(sg3)
		g5:Sub(sg3)
		g7:Sub(sg3)
		g9:Sub(sg3)
	end
	if g4:GetCount()>1 then
		local num=g4:GetCount()
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local sg4=g4:Select(1-tp,num-1,num-1,nil)
		gn:Merge(sg4)
		g6:Sub(sg4)
		g8:Sub(sg4)
		g10:Sub(sg4)
	end
	if g5:GetCount()>1 then
		local num=g5:GetCount()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg5=g5:Select(tp,num-1,num-1,nil)
		gn:Merge(sg5)
		g7:Sub(sg5)
		g9:Sub(sg5)
	end
	if g6:GetCount()>1 then
		local num=g6:GetCount()
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local sg6=g6:Select(1-tp,num-1,num-1,nil)
		gn:Merge(sg6)
		g8:Sub(sg6)
		g10:Sub(sg6)
	end
	if g7:GetCount()>1 then
		local num=g7:GetCount()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg7=g7:Select(tp,num-1,num-1,nil)
		gn:Merge(sg7)
		g9:Sub(sg7)
	end
	if g8:GetCount()>1 then
		local num=g8:GetCount()
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local sg8=g8:Select(1-tp,num-1,num-1,nil)
		gn:Merge(sg8)
		g10:Sub(sg8)
	end
	if g9:GetCount()>1 then
		local num=g9:GetCount()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg9=g9:Select(tp,num-1,num-1,nil)
		gn:Merge(sg9)
	end
	if g10:GetCount()>1 then
		local num=g10:GetCount()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg10=g10:Select(tp,num-1,num-1,nil)
		gn:Merge(sg10)
	end
	if gn:GetCount()>0 then
		Duel.SendtoGrave(gn,REASON_RULE)
		Duel.Readjust()
	end
end
--
function c1111402.op4_3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetTurnPlayer()~=c:GetControler() then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
--
function c1111402.op5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SendtoDeck(c,nil,1,REASON_EFFECT)<1 then return end
	local e5_1=Effect.CreateEffect(c)
	e5_1:SetType(EFFECT_TYPE_FIELD)
	e5_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e5_1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e5_1:SetTargetRange(1,0)
	e5_1:SetValue(c1111402.val5_1)
	e5_1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
	Duel.RegisterEffect(e5_1,tp)
end
--
function c1111402.val5_1(e,re,tp)
	return re:GetHandler():IsCode(1111402)
end
--
