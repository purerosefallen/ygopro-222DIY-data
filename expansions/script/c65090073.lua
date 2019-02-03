--天邪逆鬼的观念颠倒
function c65090073.initial_effect(c)
	--change effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,65090073+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c65090073.cecondition)
	e1:SetCost(c65090073.cecost)
	e1:SetTarget(c65090073.cetarget)
	e1:SetOperation(c65090073.ceoperation)
	c:RegisterEffect(e1)
end
function c65090073.repop1(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,nil,REASON_EFFECT)
	if sg:GetCount()>0 then
		Duel.HintSelection(sg)
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
	end
end
function c65090073.repop2(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,0,1,1,nil)
	if sg:GetCount()>0 then
		Duel.HintSelection(sg)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
function c65090073.repop3(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.SelectMatchingCard(1-tp,Card.IsAbleToHand,1-tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,1-tp,REASON_EFFECT)
		Duel.ConfirmCards(tp,sg)
	end
end
function c65090073.cecondition(e,tp,eg,ep,ev,re,r,rp)
	local ex1=re:IsHasCategory(CATEGORY_TOHAND) or re:IsHasCategory(CATEGORY_DRAW)
	local ex2=re:IsHasCategory(CATEGORY_SPECIAL_SUMMON) or re:IsHasCategory(CATEGORY_SUMMON)
	local ex3=re:IsHasCategory(CATEGORY_TOGRAVE) or re:IsHasCategory(CATEGORY_HANDES) or re:IsHasCategory(CATEGORY_DECKDES) or re:IsHasCategory(CATEGORY_DESTROY)
	return ep~=tp and (ex1 or ex2 or ex3)
end
function c65090073.costfil(c)
	return c:IsAbleToDeckAsCost() and c:IsSetCard(0x9da7) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c65090073.cecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65090073.costfil,tp,LOCATION_REMOVED,0,3,nil) end
	local g=Duel.SelectMatchingCard(tp,c65090073.costfil,tp,LOCATION_REMOVED,0,3,3,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c65090073.cetarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local ex1=re:IsHasCategory(CATEGORY_TOHAND) or re:IsHasCategory(CATEGORY_DRAW)
	local ex2=re:IsHasCategory(CATEGORY_SPECIAL_SUMMON) or re:IsHasCategory(CATEGORY_SUMMON)
	local ex3=re:IsHasCategory(CATEGORY_TOGRAVE) or re:IsHasCategory(CATEGORY_HANDES) or re:IsHasCategory(CATEGORY_DECKDES) or re:IsHasCategory(CATEGORY_DESTROY)
	if chk==0 then return (ex1 and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,0,LOCATION_HAND,1,nil,REASON_EFFECT)) or (ex2 and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil)) or (ex3 and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)) end
end
function c65090073.ceoperation(e,tp,eg,ep,ev,re,r,rp)
	local ex1=re:IsHasCategory(CATEGORY_TOHAND) or re:IsHasCategory(CATEGORY_DRAW)
	local ex2=re:IsHasCategory(CATEGORY_SPECIAL_SUMMON) or re:IsHasCategory(CATEGORY_SUMMON)
	local ex3=re:IsHasCategory(CATEGORY_TOGRAVE) or re:IsHasCategory(CATEGORY_HANDES) or re:IsHasCategory(CATEGORY_DECKDES) or re:IsHasCategory(CATEGORY_DESTROY)
	local m=3
	if ex1 and ex2 and ex3 then
		m=Duel.SelectOption(tp,aux.Stringid(65090073,0),aux.Stringid(65090073,1),aux.Stringid(65090073,2))
	elseif ex1 and ex2 then
		m=Duel.SelectOption(tp,aux.Stringid(65090073,0),aux.Stringid(65090073,1))
	elseif ex1 and ex3 then
		m=Duel.SelectOption(tp,aux.Stringid(65090073,0),aux.Stringid(65090073,2))
		if m==1 then m=2 end
	elseif ex2 and ex3 then
		m=Duel.SelectOption(tp,aux.Stringid(65090073,1),aux.Stringid(65090073,2))+1
	elseif ex1 then
		m=0
	elseif ex2 then
		m=1
	elseif ex3 then
		m=2
	end
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	if m==0 then
		Duel.ChangeChainOperation(ev,c65090073.repop1)
	elseif m==1 then
		Duel.ChangeChainOperation(ev,c65090073.repop2)
	elseif m==2 then
		Duel.ChangeChainOperation(ev,c65090073.repop3)
	end
end