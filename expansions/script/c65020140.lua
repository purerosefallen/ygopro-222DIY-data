--向魔梦夜而来
function c65020140.initial_effect(c)
	 --summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65020140+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c65020140.sumtg)
	e1:SetOperation(c65020140.sumop)
	c:RegisterEffect(e1)
	--daocaoren
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c65020140.condition)
	e2:SetCost(c65020140.cost)
	e2:SetTarget(c65020140.target)
	e2:SetOperation(c65020140.operation)
	c:RegisterEffect(e2)
end
function c65020140.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst():GetControler()~=tp and Duel.GetAttackTarget()==nil 
end
function c65020140.costfil(c)
	return c:IsSetCard(0x5da7) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c65020140.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65020140.costfil,tp,LOCATION_HAND,0,1,nil) and e:GetHandler():IsAbleToDeckAsCost() end
	local g=Duel.SelectMatchingCard(tp,c65020140.costfil,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c65020140.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c65020140.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end

function c65020140.filter(c)
	return c:IsType(TYPE_SPIRIT) and c:IsSummonable(true,nil)
end
function c65020140.filter2(c)
	return c:IsSetCard(0x5da7) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c65020140.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65020140.filter,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(c65020140.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c65020140.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c65020140.filter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.Summon(tp,g:GetFirst(),true,nil)~=0 and Duel.IsExistingMatchingCard(c65020140.filter2,tp,LOCATION_DECK,0,1,nil) then
			Duel.BreakEffect()
			local tg=Duel.SelectMatchingCard(tp,c65020140.filter2,tp,LOCATION_DECK,0,1,1,nil)
			Duel.SendtoHand(tg,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg)
		end
	end
end