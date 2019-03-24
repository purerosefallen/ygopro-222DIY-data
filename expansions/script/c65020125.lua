--响色混涂·纯真
function c65020125.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,65020115,65020119,true,true)
	--effect!
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,65020125)
	e1:SetCost(c65020125.cost)
	e1:SetTarget(c65020125.tg)
	e1:SetOperation(c65020125.op)
	c:RegisterEffect(e1)
	--change seq
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c65020125.seqcon)
	e2:SetTarget(c65020125.seqtg)
	e2:SetOperation(c65020125.seqop)
	c:RegisterEffect(e2)
end
function c65020125.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c65020125.efffil(c,e,tp)
	return c:IsSetCard(0xcda4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c65020125.aquafil(c,e,tp)
	return c:IsCode(65020115) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c65020125.eartfil(c)
	return c:IsCode(65020119) and c:IsAbleToGrave()
end
function c65020125.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c65020125.efffil(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c65020125.efffil,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and ((Duel.IsExistingMatchingCard(c65020125.aquafil,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1) or Duel.IsExistingMatchingCard(c65020125.eartfil,tp,LOCATION_REMOVED,0,1,nil)) end
	local g=Duel.SelectTarget(tp,c65020125.efffil,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c65020125.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsRelateToEffect(e) then
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
			Duel.BreakEffect()
			local b1=Duel.IsExistingMatchingCard(c65020125.aquafil,tp,LOCATION_DECK,0,1,nil,e,tp)
			local b2=Duel.IsExistingMatchingCard(c65020125.eartfil,tp,LOCATION_REMOVED,0,1,nil,e,tp)
			local m=2
			if b1 and b2 then
				m=Duel.SelectOption(tp,aux.Stringid(65020125,0),aux.Stringid(65020125,1))
			elseif b1 then
				m=0
			elseif b2 then
				m=1
			end
			if m==0 then
				local g1=Duel.SelectMatchingCard(tp,c65020125.aquafil,tp,LOCATION_DECK,0,1,1,nil,e,tp)
				Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
			elseif m==1 then
				local g2=Duel.SelectMatchingCard(tp,c65020125.eartfil,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
				Duel.SendtoGrave(g2,REASON_EFFECT)
			end
		end
	end
end

function c65020125.seqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c65020125.seqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0 end
end
function c65020125.seqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=math.log(s,2)
	Duel.MoveSequence(c,nseq)
end

