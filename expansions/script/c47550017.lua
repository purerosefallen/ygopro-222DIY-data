--孤独的龙姬 古蕾亚
function c47550017.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,c47550017.mfilter,7,2,c47550017.ovfilter,aux.Stringid(47550017,0),3,c47550017.xyzop)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(47550017,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,47550017)
	e3:SetTarget(c47550017.sptg)
	e3:SetOperation(c47550017.spop)
	c:RegisterEffect(e3)
	--counter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(47550017,1))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c47550017.ctcost)
	e1:SetTarget(c47550017.cttg)
	e1:SetOperation(c47550017.ctop)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_SET_ATTACK_FINAL)
	e2:SetCondition(c47550017.atkcon)
	e2:SetValue(4500)
	c:RegisterEffect(e2)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(47550017,2))
	e3:SetCategory(CATEGORY_DISABLE+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c47550017.distg)
	e3:SetOperation(c47550017.disop)
	c:RegisterEffect(e3) 
	--pendulum
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(47550017,3))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,47550017)
	e4:SetCondition(c47550017.pencon)
	e4:SetTarget(c47550017.pentg)
	e4:SetOperation(c47550017.penop)
	c:RegisterEffect(e4)	
end
function c47550017.mfilter(c,xyzc)
	return c:IsType(TYPE_PENDULUM) or c:IsRace(RACE_SPELLCASTER)
end
function c47550017.ovfilter(c)
	return c:IsFaceup() and c:IsCode(47550015)
end
function c47550017.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,47550017)==0 end
	Duel.RegisterFlagEffect(tp,47550017,RESET_PHASE+PHASE_END,0,1)
end
function c47550017.ctcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c47550017.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function c47550017.ctop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x15d9,1)
		tc=g:GetNext()
	end
end
function c47550017.atkcon(e)
	local c=e:GetHandler()
	local ph=Duel.GetCurrentPhase()
	local bc=c:GetBattleTarget()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) and bc:GetCounter(0x15d9)>0
end
function c47550017.disfilter(c)
	return c:IsType(TYPE_MONSTER) and c:GetCounter(0x15d9)>0
end
function c47550017.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c47550017.disfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c47550017.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectMatchingCard(tp,c47550017.disfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	if ((tc:IsFaceup() and not tc:IsDisabled()) or tc:IsType(TYPE_TRAPMONSTER)) and Duel.Damage(1-tp,1000,REASON_EFFECT) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetCode(EFFECT_IMMUNE_EFFECT)
		e3:SetValue(c47550017.efilter)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end
	end
end
function c47550017.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c47550017.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_XYZ) and c:IsFaceup()
end
function c47550017.pspfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_PENDULUM) and c:IsCanAddCounter(0x1,1,false,LOCATION_ONFIELD)
end
function c47550017.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c47550017.pspfilter,tp,LOCATION_PZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c47550017.penop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c47550017.pspfilter,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
	   tc:AddCounter(0x1,3)
	   Duel.BreakEffect()
	   Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c47550017.spfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER) and c:IsType(TYPE_PENDULUM)
end
function c47550017.odfilter(c)
	return c:IsAbleToChangeControler() and not c:IsType(TYPE_TOKEN)
end
function c47550017.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c47550017.spfilter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingTarget(c47550017.odfilter,tp,0,LOCATION_ONFIELD,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g1=Duel.SelectTarget(tp,c47550017.spfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g2=Duel.SelectTarget(tp,c47550017.odfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c47550017.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local tc=g:GetFirst()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		while tc do
			local og=tc:GetOverlayGroup()
			if og:GetCount()>0 then
				Duel.SendtoGrave(og,REASON_RULE)
			end
			Duel.Overlay(c,Group.FromCards(tc))
			tc=g:GetNext()
		end
	end
end