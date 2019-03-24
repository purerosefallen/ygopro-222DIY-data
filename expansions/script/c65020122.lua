--响色混涂·璀燃
function c65020122.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,65020113,65020117,true,true)
	--effect!
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,65020122)
	e1:SetCost(c65020122.cost)
	e1:SetTarget(c65020122.tg)
	e1:SetOperation(c65020122.op)
	c:RegisterEffect(e1)
	--change seq
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c65020122.seqcon)
	e2:SetTarget(c65020122.seqtg)
	e2:SetOperation(c65020122.seqop)
	c:RegisterEffect(e2)
end
function c65020122.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c65020122.windfil(c)
	return c:IsCode(65020113) and c:IsAbleToHand()
end
function c65020122.firefil(c,e,tp)
	return c:IsCode(65020117) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c65020122.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) and (Duel.IsExistingMatchingCard(c65020122.windfil,tp,LOCATION_GRAVE,0,1,nil) or Duel.IsExistingMatchingCard(c65020122.firefil,tp,LOCATION_HAND,0,1,nil,e,tp)) end
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c65020122.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then
			Duel.BreakEffect()
			local b1=Duel.IsExistingMatchingCard(c65020122.windfil,tp,LOCATION_GRAVE,0,1,nil)
			local b2=Duel.IsExistingMatchingCard(c65020122.firefil,tp,LOCATION_HAND,0,1,nil,e,tp)
			local m=2
			if b1 and b2 then
				m=Duel.SelectOption(tp,aux.Stringid(65020122,0),aux.Stringid(65020122,1))
			elseif b1 then
				m=0
			elseif b2 then
				m=1
			end
			if m==0 then
				local g1=Duel.SelectMatchingCard(tp,c65020122.windfil,tp,LOCATION_GRAVE,0,1,1,nil)
				Duel.SendtoHand(g1,tp,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g1)
			elseif m==1 then
				local g2=Duel.SelectMatchingCard(tp,c65020122.firefil,tp,LOCATION_HAND,0,1,1,nil,e,tp)
				Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
function c65020122.seqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c65020122.seqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0 end
end
function c65020122.seqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=math.log(s,2)
	Duel.MoveSequence(c,nseq)
end
