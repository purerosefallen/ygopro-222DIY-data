--响色混涂·游晃
function c65020124.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,65020115,65020117,true,true)
	--effect!
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,65020124)
	e1:SetCost(c65020124.cost)
	e1:SetTarget(c65020124.tg)
	e1:SetOperation(c65020124.op)
	c:RegisterEffect(e1)
	--change seq
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c65020124.seqcon)
	e2:SetTarget(c65020124.seqtg)
	e2:SetOperation(c65020124.seqop)
	c:RegisterEffect(e2)
end
function c65020124.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c65020124.efffil(c)
	return c:IsAbleToRemove() and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function c65020124.aquafil(c,e,tp)
	return c:IsCode(65020115) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c65020124.firefil(c,e,tp)
	return c:IsCode(65020117) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c65020124.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65020124.efffil,tp,0,LOCATION_GRAVE+LOCATION_EXTRA,1,nil) and (Duel.IsExistingMatchingCard(c65020124.aquafil,tp,LOCATION_DECK,0,1,nil,e,tp) or Duel.IsExistingMatchingCard(c65020124.firefil,tp,LOCATION_HAND,0,1,nil,e,tp)) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_GRAVE+LOCATION_EXTRA)
end
function c65020124.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c65020124.efffil,tp,0,LOCATION_GRAVE+LOCATION_EXTRA,1,1,nil)
	if g:GetCount()>0 then
		if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
			Duel.BreakEffect()
			local b1=Duel.IsExistingMatchingCard(c65020124.aquafil,tp,LOCATION_DECK,0,1,nil,e,tp)
			local b2=Duel.IsExistingMatchingCard(c65020124.firefil,tp,LOCATION_HAND,0,1,nil,e,tp)
			local m=2
			if b1 and b2 then
				m=Duel.SelectOption(tp,aux.Stringid(65020124,0),aux.Stringid(65020124,1))
			elseif b1 then
				m=0
			elseif b2 then
				m=1
			end
			if m==0 then
				local g1=Duel.SelectMatchingCard(tp,c65020124.aquafil,tp,LOCATION_DECK,0,1,1,nil,e,tp)
				Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
			elseif m==1 then
				local g2=Duel.SelectMatchingCard(tp,c65020124.firefil,tp,LOCATION_HAND,0,1,1,nil,e,tp)
				Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
function c65020124.seqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c65020124.seqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0 end
end
function c65020124.seqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=math.log(s,2)
	Duel.MoveSequence(c,nseq)
end
