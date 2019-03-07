--星罗迷域
function c79131350.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,79131351)
	e1:SetOperation(c79131350.activate)
	c:RegisterEffect(e1)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetTarget(c79131350.target)
	e2:SetValue(c79131350.efilter)
	c:RegisterEffect(e2)
	--TODAMAGE
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,79131350)
	e3:SetTarget(c79131350.damtg)
	e3:SetOperation(c79131350.damop)
	c:RegisterEffect(e3)
end
function c79131350.thfilter1(c)
	return c:IsSetCard(0x79a) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c79131350.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c79131350.thfilter1,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(79131350,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c79131350.target(e,c)
	return c:IsSetCard(0x79a) and c:IsType(TYPE_TRAP+TYPE_SPELL)
end
function c79131350.efilter(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c79131350.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x79a)
end
function c79131350.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79131350.cfilter,tp,LOCATION_EXTRA,0,1,nil) end
	local ct=Duel.GetMatchingGroupCount(c79131350.cfilter,tp,LOCATION_EXTRA,0,nil)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(ct*100)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*100)
end
function c79131350.damop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ct=Duel.GetMatchingGroupCount(c79131350.cfilter,tp,LOCATION_EXTRA,0,nil)
	Duel.Damage(p,ct*100,REASON_EFFECT)
end