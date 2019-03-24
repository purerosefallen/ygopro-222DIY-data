--响色混涂·繁华
function c65020121.initial_effect(c)
	 --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,65020113,65020115,true,true)
	--effect!
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,65020121)
	e1:SetCost(c65020121.cost)
	e1:SetTarget(c65020121.tg)
	e1:SetOperation(c65020121.op)
	c:RegisterEffect(e1)
	--change seq
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c65020121.seqcon)
	e2:SetTarget(c65020121.seqtg)
	e2:SetOperation(c65020121.seqop)
	c:RegisterEffect(e2)
end
function c65020121.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c65020121.efffil(c)
	return c:IsSetCard(0xcda4) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c65020121.windfil(c)
	return c:IsCode(65020113) and c:IsAbleToHand()
end
function c65020121.aquafil(c,e,tp)
	return c:IsCode(65020115) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c65020121.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65020121.efffil,tp,LOCATION_DECK,0,1,nil) and (Duel.IsExistingMatchingCard(c65020121.windfil,tp,LOCATION_GRAVE,0,1,nil) or Duel.IsExistingMatchingCard(c65020121.aquafil,tp,LOCATION_DECK,0,1,nil,e,tp)) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c65020121.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c65020121.efffil,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoHand(g,tp,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,g)
			Duel.BreakEffect()
			local b1=Duel.IsExistingMatchingCard(c65020121.windfil,tp,LOCATION_GRAVE,0,1,nil)
			local b2=Duel.IsExistingMatchingCard(c65020121.aquafil,tp,LOCATION_DECK,0,1,nil,e,tp)
			local m=2
			if b1 and b2 then
				m=Duel.SelectOption(tp,aux.Stringid(65020121,0),aux.Stringid(65020121,1))
			elseif b1 then
				m=0
			elseif b2 then
				m=1
			end
			if m==0 then
				local g1=Duel.SelectMatchingCard(tp,c65020121.windfil,tp,LOCATION_GRAVE,0,1,1,nil)
				Duel.SendtoHand(g1,tp,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g1)
			elseif m==1 then
				local g2=Duel.SelectMatchingCard(tp,c65020121.aquafil,tp,LOCATION_DECK,0,1,1,nil,e,tp)
				Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
function c65020121.seqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c65020121.seqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0 end
end
function c65020121.seqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=math.log(s,2)
	Duel.MoveSequence(c,nseq)
end