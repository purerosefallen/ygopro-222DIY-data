--凛冬季节·独处时光
function c81000512.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(c81000512.tgcon)
	e2:SetTarget(c81000512.tglimit)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,81000512)
	e3:SetCondition(c81000512.rmcon)
	e3:SetTarget(c81000512.rmtg)
	e3:SetOperation(c81000512.rmop)
	c:RegisterEffect(e3)
	--to deck
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,81097114)
	e4:SetCondition(aux.exccon)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(c81000512.tdtg)
	e4:SetOperation(c81000512.tdop)
	c:RegisterEffect(e4)
end
function c81000512.tgcon(e)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end
function c81000512.tglimit(e,c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_PENDULUM)
end
function c81000512.cfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsCode(81000016,81008004) and c:IsSummonType(SUMMON_TYPE_RITUAL)
end
function c81000512.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c81000512.cfilter,1,nil,tp)
end
function c81000512.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE)
end
function c81000512.rmop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	local opt=0
	if g1:GetCount()>0 and g2:GetCount()>0 then
		opt=Duel.SelectOption(tp,aux.Stringid(81000512,2),aux.Stringid(81000512,3))
	elseif g1:GetCount()>0 then
		opt=0
	elseif g2:GetCount()>0 then
		opt=1
	else
		return
	end
	local sg=nil
	if opt==0 then
		sg=g1:RandomSelect(tp,1)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		sg=g2:Select(tp,1,1,nil)
	end
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end
function c81000512.tdfilter(c,e)
	return c:IsType(TYPE_RITUAL) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_PENDULUM)) and c:IsAbleToDeck()
end
function c81000512.tdcheck(g)
	return g:GetClassCount(Card.GetCode)==#g
end
function c81000512.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c81000512.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c81000512.tdfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.GetMatchingGroup(c81000512.tdfilter,tp,LOCATION_GRAVE,0,e:GetHandler(),e)
	local sg=g:SelectSubGroup(tp,c81000512.tdcheck,false,1,#g)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,#sg,0,0)
end
function c81000512.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
