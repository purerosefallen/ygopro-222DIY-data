--超时空战斗机-Fang Varn
function c13257344.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e8:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e8)
	--special summon
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetCode(EFFECT_SPSUMMON_PROC)
	e9:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e9:SetRange(LOCATION_HAND)
	e9:SetCondition(c13257344.spcon)
	e9:SetOperation(c13257344.spop)
	c:RegisterEffect(e9)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetTarget(c13257344.eqtg)
	e1:SetOperation(c13257344.eqop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13257344,5))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCondition(c13257344.eqcon1)
	e2:SetTarget(c13257344.eqtg1)
	e2:SetOperation(c13257344.eqop1)
	c:RegisterEffect(e2)
	--Power Capsule
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(13257344,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCondition(c13257344.pccon)
	e3:SetTarget(c13257344.pctg)
	e3:SetOperation(c13257344.pcop)
	c:RegisterEffect(e3)
	eflist={"power_capsule",e3}
	c13257344[c]=eflist
	
end
function c13257344.spfilter(c,ft,tp)
	return c:IsSetCard(0x351)
		and c:IsControler(tp) and c:IsAbleToGraveAsCost() and (ft>0 or c:GetSequence()<5)
end
function c13257344.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.IsExistingMatchingCard(c13257344.spfilter,tp,LOCATION_MZONE,0,1,nil,ft,tp)
end
function c13257344.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c13257344.spfilter,tp,LOCATION_MZONE,0,1,1,nil,ft,tp)
	Duel.SendtoGrave(g,REASON_COST)
	Duel.Hint(11,0,aux.Stringid(13257344,7))
end
function c13257344.eqfilter(c,ec)
	return c:IsSetCard(0x352) and c:IsType(TYPE_MONSTER) and c:CheckEquipTarget(ec)
end
function c13257344.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c13257344.eqfilter,tp,LOCATION_EXTRA,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_EXTRA)
end
function c13257344.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c13257344.eqfilter,tp,LOCATION_EXTRA,0,1,1,nil,c)
	local tc=g:GetFirst()
	if tc then
		Duel.Equip(tp,tc,c)
	end
end
function c13257344.tdfilter(c,ec,tp)
	return c:IsSetCard(0x352) and c:IsType(TYPE_MONSTER) and c:IsFaceup() and ((c:CheckEquipTarget(ec) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0) or c:IsAbleToExtra())
end
function c13257344.cfilter1(c,tp)
	return c:GetPreviousControler()==tp and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c13257344.eqcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c13257344.cfilter1,1,nil,1-tp)
end
function c13257344.eqtg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c13257344.tdfilter(chkc,c,tp) end
	if chk==0 then return Duel.IsExistingTarget(c13257344.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,c,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c13257344.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,c,tp)
end
function c13257344.eqop1(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local sc=sg:GetCount()
	if sc==0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() and Duel.GetLocationCount(tp,LOCATION_SZONE)>=sc and Duel.SelectYesNo(tp,aux.Stringid(13257344,6)) then
		local tc=sg:GetFirst()
		while tc do
			Duel.Equip(tp,tc,c,true,true)
			tc=sg:GetNext()
		end
		Duel.EquipComplete()
	else
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	end
end
function c13257344.pcfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
end
function c13257344.pccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c13257344.pcfilter,1,nil,1-tp)
end
function c13257344.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local t1=c:GetEquipCount()>0 or Duel.IsExistingMatchingCard(c13257344.eqfilter,tp,LOCATION_EXTRA,0,1,nil,c)
	local t2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,93130022,0,0x4011,c:GetAttack(),c:GetDefense(),c:GetLevel(),c:GetRace(),c:GetAttribute())
	if chk==0 then return t1 or t2 end
	local op=0
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(13257344,1))
	if t1 and t2 then
		op=Duel.SelectOption(tp,aux.Stringid(13257344,2),aux.Stringid(13257344,3))
	elseif t1 then
		op=Duel.SelectOption(tp,aux.Stringid(13257344,2))
	elseif t2 then
		op=Duel.SelectOption(tp,aux.Stringid(13257344,3))+1
	end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_EQUIP)
		Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_EXTRA)
	elseif op==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	end
end
function c13257344.pcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		local eq=c:GetEquipGroup()
		local g=eq:Filter(Card.IsAbleToDeck,nil)
		local op=0
		if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
		if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and g:GetCount()>0 and (not Duel.IsExistingMatchingCard(c13257344.eqfilter,tp,LOCATION_EXTRA,0,1,nil,c) or Duel.SelectYesNo(tp,aux.Stringid(13257344,4))) then op=1
		elseif Duel.GetLocationCount(tp,LOCATION_SZONE)==0 and g:GetCount()>0 then op=1
		end
		if op==1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local sg=g:Select(tp,1,1,nil)
			Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
		end
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		g=Duel.SelectMatchingCard(tp,c13257344.eqfilter,tp,LOCATION_EXTRA,0,1,1,nil,c)
		local tc=g:GetFirst()
		if tc then
			Duel.Equip(tp,tc,c)
		end
	elseif e:GetLabel()==1 then
		local atk=c:GetAttack()
		local def=c:GetDefense()
		local lv=c:GetLevel()
		local race=c:GetRace()
		local att=c:GetAttribute()
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not c:IsRelateToEffect(e) or c:IsFacedown()
			or not Duel.IsPlayerCanSpecialSummonMonster(tp,93130022,0,0x4011,atk,def,lv,race,att) then return end
		local token=Duel.CreateToken(tp,93130022)
		c:CreateRelation(token,RESET_EVENT+0x1fe0000)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(c13257344.tokenatk)
		e1:SetReset(RESET_EVENT+0xfe0000)
		token:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetValue(c13257344.tokendef)
		token:RegisterEffect(e2,true)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CHANGE_LEVEL)
		e3:SetValue(c13257344.tokenlv)
		e3:SetReset(RESET_EVENT+0xfe0000)
		token:RegisterEffect(e3,true)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_CHANGE_RACE)
		e4:SetValue(c13257344.tokenrace)
		e4:SetReset(RESET_EVENT+0xfe0000)
		token:RegisterEffect(e4,true)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e5:SetValue(c13257344.tokenatt)
		e5:SetReset(RESET_EVENT+0xfe0000)
		token:RegisterEffect(e5,true)
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetCode(EFFECT_SELF_DESTROY)
		e6:SetCondition(c13257344.tokendes)
		e6:SetReset(RESET_EVENT+0xfe0000)
		token:RegisterEffect(e6,true)
		Duel.SpecialSummonComplete()
		c:SetCardTarget(token)
	end
end
function c13257344.tokenatk(e,c)
	return e:GetOwner():GetAttack()
end
function c13257344.tokendef(e,c)
	return e:GetOwner():GetDefense()
end
function c13257344.tokenlv(e,c)
	return e:GetOwner():GetLevel()
end
function c13257344.tokenrace(e,c)
	return e:GetOwner():GetRace()
end
function c13257344.tokenatt(e,c)
	return e:GetOwner():GetAttribute()
end
function c13257344.tokendes(e)
	return not e:GetOwner():IsRelateToCard(e:GetHandler())
end
