--Revatail Jakuri
function c98301060.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c98301060.spcon)
	e1:SetOperation(c98301060.spop)
	c:RegisterEffect(e1)
	--download
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98301060,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,98301060)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c98301060.dlcon)
	e2:SetTarget(c98301060.dltg)
	e2:SetOperation(c98301060.dlop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98301060,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c98301060.thcon)
	e3:SetTarget(c98301060.thtg)
	e3:SetOperation(c98301060.thop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMING_STANDBY_PHASE+TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetCondition(c98301060.thcon2)
	c:RegisterEffect(e4)
	--cannot be target
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(aux.tgoval)
	c:RegisterEffect(e5)
	--field indes
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(LOCATION_FZONE,0)
	e6:SetTarget(c98301060.indtg)
	e6:SetValue(aux.indoval)
	c:RegisterEffect(e6)
	--to deck
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e7:SetCode(EVENT_CHAINING)
	e7:SetRange(LOCATION_MZONE)
	e7:SetOperation(aux.chainreg)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(98301060,3))
	e8:SetCategory(CATEGORY_TODECK)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e8:SetCode(EVENT_CHAIN_SOLVED)
	e8:SetRange(LOCATION_MZONE)
	e8:SetProperty(EFFECT_FLAG_DELAY)
	e8:SetCountLimit(1)
	e8:SetCondition(c98301060.tdcon)
	e8:SetOperation(c98301060.tdtg)
	e8:SetOperation(c98301060.tdop)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(98301060)
	c:RegisterEffect(e9)
end

function c98301060.spfilter(c,ft,tp)
	return c:IsCode(98301020)
		and (ft>0 or (c:IsControler(tp) and c:GetSequence()<5)) and (c:IsControler(tp) or c:IsFaceup())
end
function c98301060.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.CheckReleaseGroup(tp,c98301060.spfilter,1,nil,ft,tp)
end
function c98301060.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.SelectReleaseGroup(tp,c98301060.spfilter,1,1,nil,ft,tp)
	Duel.Release(g,REASON_COST)
end

function c98301060.dlcon(e,tp,eg,ep,ev,re,r,rp)
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		local tc=te:GetHandler()
		if tgp==tp and (tc:IsSetCard(0xad3) or tc:IsSetCard(0xad4)) then
			return true
		end
	end
	return false
end
function c98301060.dltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,98301060)==0 end
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
function c98301060.dlop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,98301060)~=0 then return false end
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
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(98301060,4))
	local dl=dg:Select(tp,1,1,nil)
	local dlc=dl:GetFirst():GetCode()
	Duel.RegisterFlagEffect(tp,98301060,nil,0,1,dlc)
end

function c98301060.thfilter(c,tp)
	local cod=Duel.GetFlagEffectLabel(tp,98301060)
	return c:IsCode(cod) and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c98301060.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c98301060.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c98301060.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c98301060.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c98301060.thcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,98300000)
end
function c98301060.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,98300000)
end
function c98301060.indtg(e,c)
	return c:IsSetCard(0xad1)
end

function c98301060.tdfilter(c,tp)
	return c:IsControler(1-tp)
end
function c98301060.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rc:GetType()==TYPE_SPELL and (rc:IsSetCard(0xad3) or rc:IsSetCard(0xad4)) and rp==tp and Duel.IsExistingMatchingCard(c98301060.tdfilter,tp,0,LOCATION_ONFIELD,1,nil,tp) and e:GetHandler():GetFlagEffect(1)>0
end
function c98301060.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98301060.tdfilter,tp,0,LOCATION_ONFIELD,1,nil,tp) end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c98301060.tdop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c98301060.tdfilter,tp,0,LOCATION_ONFIELD,1,nil,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,c98301060.tdfilter,tp,0,LOCATION_ONFIELD,1,1,nil,tp)
		if g:GetCount()>0 then
			Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		end
	end
end