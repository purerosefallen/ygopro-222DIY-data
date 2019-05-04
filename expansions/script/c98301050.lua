--Revatail Frelia
function c98301050.initial_effect(c)
	c:EnableReviveLimit()
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c98301050.spcon)
	c:RegisterEffect(e1)
	--spmmon limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c98301050.sumlimit)
	c:RegisterEffect(e2,tp)
	--download
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98301050,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1,98301050)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c98301050.dlcon)
	e3:SetTarget(c98301050.dltg)
	e3:SetOperation(c98301050.dlop)
	c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98301050,2))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c98301050.thcon)
	e4:SetTarget(c98301050.thtg)
	e4:SetOperation(c98301050.thop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(0,TIMING_STANDBY_PHASE+TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e5:SetCondition(c98301050.thcon2)
	c:RegisterEffect(e5)
	--immune trap
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_IMMUNE_EFFECT)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetValue(c98301050.efilter)
	c:RegisterEffect(e6)
	--search Field
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(98301050,3))
	e7:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetProperty(EFFECT_FLAG_DELAY)
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	e7:SetTarget(c98301050.thtg2)
	e7:SetOperation(c98301050.thop2)
	c:RegisterEffect(e7)
	--search and flip
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(98301050,3))
	e8:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e8:SetProperty(EFFECT_FLAG_DELAY)
	e8:SetTarget(c98301050.thtg3)
	e8:SetOperation(c98301050.thop3)
	c:RegisterEffect(e8)
end

function c98301050.spfilter(c)
	return c:IsFacedown() or c:IsAttackPos()
end
function c98301050.spcon(e,c)
	if c==nil then return true end
	if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)<=0 then return false end
	return not Duel.IsExistingMatchingCard(c98301050.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c98301050.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not (c:IsSetCard(0xad1) or c:IsSetCard(0xad2))
end
function c98301050.dlcon(e,tp,eg,ep,ev,re,r,rp)
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		local tc=te:GetHandler()
		if tgp==tp and (tc:IsSetCard(0xad3) or tc:IsSetCard(0xad4)) then
			return true
		end
	end
	return false
end
function c98301050.dltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,98301050)==0 end
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
function c98301050.dlop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,98301050)~=0 then return false end
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
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(98301050,4))
	local dl=dg:Select(tp,1,1,nil)
	local dlc=dl:GetFirst():GetCode()
	Duel.RegisterFlagEffect(tp,98301050,nil,0,1,dlc)
end

function c98301050.thfilter(c,tp)
	local cod=Duel.GetFlagEffectLabel(tp,98301050)
	return c:IsCode(cod) and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c98301050.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c98301050.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c98301050.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c98301050.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c98301050.thcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,98300000)
end
function c98301050.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,98300000)
end

function c98301050.efilter(e,te)
	return te:IsActiveType(TYPE_TRAP) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

function c98301050.thfilter2(c)
	return c:IsSetCard(0xad1) and c:IsType(TYPE_FIELD) and c:IsAbleToHand()
end
function c98301050.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98301050.thfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98301050.thop2(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c98301050.thfilter2,tp,LOCATION_DECK,0,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98301050.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	Duel.BreakEffect()
	if e:GetHandler():IsRelateToEffect(e) and e:GetHandler():IsCanTurnSet() and e:GetHandler():IsFaceup() then
		Duel.ChangePosition(e:GetHandler(),POS_FACEDOWN_DEFENSE)
	end
end

function c98301050.thfilter3(c)
	return c:IsSetCard(0xad1) and c:IsAbleToHand()  and not c:IsType(TYPE_FIELD)
end
function c98301050.thtg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98301050.thfilter3,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98301050.thop3(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c98301050.thfilter3,tp,LOCATION_DECK,0,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98301050.thfilter3,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end