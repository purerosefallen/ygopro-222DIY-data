--Misya
function c98301030.initial_effect(c)
	--download
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98301030,1))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,98301030)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c98301030.dlcon)
	e1:SetTarget(c98301030.dltg)
	e1:SetOperation(c98301030.dlop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98301030,2))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c98301030.thcon)
	e2:SetTarget(c98301030.thtg)
	e2:SetOperation(c98301030.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_STANDBY_PHASE+TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCondition(c98301030.thcon2)
	c:RegisterEffect(e3)
	--destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c98301030.destg)
	e4:SetValue(c98301030.value)
	e4:SetOperation(c98301030.desop)
	c:RegisterEffect(e4)
end
function c98301030.dlcon(e,tp,eg,ep,ev,re,r,rp)
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		local tc=te:GetHandler()
		if tgp==tp and (tc:IsSetCard(0xad3) or tc:IsSetCard(0xad4)) then
			return true
		end
	end
	return false
end
function c98301030.dltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,98301030)==0 end
	local dg=Group.CreateGroup()
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		local tc=te:GetHandler()
		if tgp==tp and (tc:IsSetCard(0xad3) or tc:IsSetCard(0xad4)) then
			dg:AddCard(tc)
		end
	end
	Duel.SetTargetCard(dg)
end
function c98301030.dlop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,98301030)~=0 then return false end
	local dg=Group.CreateGroup()
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
			local tc=te:GetHandler()
		if tgp==tp and (tc:IsSetCard(0xad3) or tc:IsSetCard(0xad4)) then
			if tc then
				dg:AddCard(tc)
			end
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(98301030,4))
	local dl=dg:Select(tp,1,1,nil)
	local dlc=dl:GetFirst():GetCode()
	Duel.RegisterFlagEffect(tp,98301030,nil,0,1,dlc)
end

function c98301030.thfilter(c,tp)
	local cod=Duel.GetFlagEffectLabel(tp,98301030)
	return c:IsCode(cod) and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c98301030.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c98301030.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c98301030.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c98301030.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c98301030.thcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,98300000)
end
function c98301030.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,98300000)
end

function c98301030.dfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsSetCard(0xad2) and not c:IsCode(98301030)
end
function c98301030.dtgfilter(c)
	return c:IsLocation(LOCATION_HAND) and c:IsAbleToGrave() and (c:IsSetCard(0xad3) or c:IsSetCard(0xad4))
end
function c98301030.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local count=eg:FilterCount(c98301030.dfilter,nil)
		return count>0 and (Duel.IsExistingMatchingCard(c98301030.dtgfilter,tp,LOCATION_HAND,0,1,nil) or e:GetHandler():IsAbleToHand())
	end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(98301030,3))
end
function c98301030.value(e,c)
	return c:IsFaceup() and c:GetLocation()==LOCATION_MZONE and c:IsSetCard(0xad2) and not c:IsCode(98301030) and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c98301030.desop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c98301030.dtgfilter,tp,LOCATION_HAND,0,1,nil) and Duel.SelectOption(tp,aux.Stringid(98301030,5),aux.Stringid(98301030,6))==0 then
		local tg=Duel.SelectMatchingCard(tp,c98301030.dtgfilter,tp,LOCATION_HAND,0,1,1,nil)
		Duel.SendtoGrave(tg,REASON_EFFECT+REASON_REPLACE)
	else
		if e:GetHandler():IsAbleToHand() then
			Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT+REASON_REPLACE)
		end
	end
end
