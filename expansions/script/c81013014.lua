--天光少女·白石紬
function c81013014.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_RELEASE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,81013014)
	e1:SetCondition(c81013014.thcon)
	e1:SetTarget(c81013014.thtg)
	e1:SetOperation(c81013014.thop)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c81013014.efilter)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--avoid battle damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c81013014.efilter)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--shuffle & draw
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,81013014)
	e4:SetCondition(c81013014.drcon)
	e4:SetTarget(c81013014.drtg)
	e4:SetOperation(c81013014.drop)
	c:RegisterEffect(e4)
end
function c81013014.efilter(e,c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_PENDULUM)
end
function c81013014.thcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end
function c81013014.thfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_RITUAL) and c:IsAbleToHand()
end
function c81013014.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81013014.thfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
end
function c81013014.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81013014.thfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c81013014.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c81013014.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_DECK) or e:GetHandler():IsPreviousLocation(LOCATION_EXTRA)
end
function c81013014.filter(c,e)
	return c:IsType(TYPE_RITUAL) and (c:IsType(TYPE_PENDULUM) or c:IsType(TYPE_SPELL)) and c:IsAbleToDeck() and c:IsCanBeEffectTarget(e)
end
function c81013014.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c81013014.filter(chkc,e) end
	local g=Duel.GetMatchingGroup(c81013014.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e)
	if chk==0 then return g:GetClassCount(Card.GetCode)>=5 and Duel.IsPlayerCanDraw(tp,2) end
	local sg=Group.CreateGroup()
	for i=1,5 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if tc then
			sg:AddCard(tc)
			g:Remove(Card.IsCode,nil,tc:GetCode())
		end
	end
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,sg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c81013014.drop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=5 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct>0 then
		Duel.BreakEffect()
		Duel.Draw(tp,2,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c81013014.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c81013014.splimit(e,c)
	return not ((c:IsAttack(1550) and c:IsDefense(1050)) or (c:IsType(TYPE_RITUAL) and c:IsType(TYPE_PENDULUM)))
end
