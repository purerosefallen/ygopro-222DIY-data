--艺形魔-纸昆丁虎
function c21520187.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetDescription(aux.Stringid(21520187,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,21520187)
	e1:SetCondition(c21520187.thcon2)
	e1:SetCost(c21520187.thcost2)
	e1:SetTarget(c21520187.thtg2)
	e1:SetOperation(c21520187.thop2)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21520187,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,21520187)
	e2:SetTarget(c21520187.searchtg)
	e2:SetOperation(c21520187.searchop)
	c:RegisterEffect(e2)
	local e2_2=e2:Clone()
	e2_2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2_2)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DECKDES)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e3:SetDescription(aux.Stringid(21520187,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c21520187.tgcon)
	e3:SetTarget(c21520187.tgtg)
	e3:SetOperation(c21520187.tgop)
	c:RegisterEffect(e3)
end
function c21520187.tgfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_FIEND)
end
function c21520187.thfilter(c)
	return c:IsSetCard(0x490) and c:IsAbleToHand() and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_DECK,0,c:GetLevel()+1,nil) and c:IsType(TYPE_MONSTER)
end
function c21520187.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetType()&(TYPE_SPELL+TYPE_CONTINUOUS)==TYPE_SPELL+TYPE_CONTINUOUS
end
function c21520187.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c21520187.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c21520187.tgfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c21520187.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,g:GetFirst():GetLevel(),tp,0)
end
function c21520187.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		local lv=tc:GetLevel()
		Duel.DiscardDeck(tp,lv,REASON_EFFECT)
		if not tc:IsSetCard(0x490) then
			local sum=tc:GetAttack()+tc:GetDefense()
			Duel.Damage(tp,sum,REASON_RULE)
		end
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c21520187.fieldfilter(c)
	return c:IsCode(21520181) and c:IsFaceup()
end
function c21520187.thcon2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c21520187.fieldfilter,tp,LOCATION_ONFIELD,0,1,nil) then 
		return Duel.GetTurnPlayer()==tp or Duel.GetTurnPlayer()==1-tp
	else
		return Duel.GetTurnPlayer()==tp
	end
end
function c21520187.thcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_DISCARD+REASON_COST)
end
function c21520187.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21520187.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SEARCH+CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c21520187.thop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c21520187.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local thg=g:Select(tp,1,1,nil)
	Duel.SendtoHand(thg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,thg)
	Duel.BreakEffect()
	local rg=Duel.GetDecktopGroup(tp,thg:GetFirst():GetLevel())
	Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
end
function c21520187.shfilter(c)
	return c:IsRace(RACE_FIEND) and c:IsAbleToHand() and c:GetCode()~=21520187 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_DECK,0,c:GetLevel()+1,nil)
end
function c21520187.searchtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21520187.shfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c21520187.searchop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c21520187.shfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleDeck(tp)
	Duel.BreakEffect()
	local rg=Duel.GetDecktopGroup(tp,g:GetFirst():GetLevel())
	Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
end
