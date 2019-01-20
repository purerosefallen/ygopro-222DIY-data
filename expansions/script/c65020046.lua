--暮色居城 诅咒
function c65020046.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,65020046)
	e1:SetCost(c65020046.cost)
	e1:SetTarget(c65020046.tg)
	e1:SetOperation(c65020046.op)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCost(c65020046.cost)
	e2:SetTarget(c65020046.retg)
	e2:SetOperation(c65020046.reop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--remove!
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,65020046)
	e4:SetCondition(c65020046.con)
	e4:SetTarget(c65020046.remtg)
	e4:SetOperation(c65020046.remop)
	c:RegisterEffect(e4)
end
function c65020046.con(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_REMOVED,0,nil)
	local b=Duel.GetFieldGroupCount(tp,0,LOCATION_REMOVED)
	return a>b and eg:IsExists(Card.IsControler,1,nil,1-tp)
end
function c65020046.remtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(Card.IsControler,nil,1-tp)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g:GetCount(),0,0)
end
function c65020046.remop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(Card.IsControler,nil,1-tp)
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
end
function c65020046.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,7)
	if chk==0 then return g:FilterCount(Card.IsAbleToRemoveAsCost,nil)==7
	 end
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function c65020046.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,0)
end
function c65020046.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
function c65020046.thfil(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsSetCard(0x5da1) and c:IsAbleToHand()
end
function c65020046.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c65020046.reop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c65020046.thfil,tp,LOCATION_DECK,0,2,nil) then return end
	local g=Duel.SelectMatchingCard(tp,c65020046.thfil,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoHand(g,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
end
