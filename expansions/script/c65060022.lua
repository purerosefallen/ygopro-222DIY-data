--梦之德莱姆
function c65060022.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,65060023+EFFECT_COUNT_CODE_OATH)
	e0:SetTarget(c65060022.target)
	e0:SetOperation(c65060022.activate)
	c:RegisterEffect(e0)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCondition(c65060022.discon)
	e1:SetTarget(c65060022.distg)
	e1:SetOperation(c65060022.disop)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DAMAGE+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_CARD_TARGET)  
	e2:SetCountLimit(1,65060022)
	e2:SetTarget(c65060022.damtg)
	e2:SetOperation(c65060022.damop)
	c:RegisterEffect(e2)
end
function c65060022.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and Duel.IsChainNegatable(ev)
end

function c65060022.thfilter(c)
	return c:IsSetCard(0x6da4) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c65060022.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65060022.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c65060022.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c65060022.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c65060022.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x6da4) and not c:IsType(TYPE_LINK)
end
function c65060022.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c65060022.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c65060022.filter,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.SelectTarget(tp,c65060022.filter,tp,LOCATION_MZONE,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,g,1,0,0)
end
function c65060022.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) then
		if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsRelateToEffect(re) then
			Duel.SendtoGrave(eg,REASON_EFFECT)
		end
		local tc=Duel.GetFirstTarget()
		if tc:IsFaceup() and tc:IsRelateToEffect(e) then
			Duel.BreakEffect()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(300)
			tc:RegisterEffect(e1)
		end
	end
end

function c65060022.damtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c65060022.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c65060022.filter,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.SelectTarget(tp,c65060022.filter,tp,LOCATION_MZONE,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,g,1,0,0)
end

function c65060022.damop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local g1=Duel.GetMatchingGroup(c65060022.filter,tp,LOCATION_MZONE,0,nil)
	local mc=g1:GetFirst()
	local dam=0
	while mc do
		dam=dam+mc:GetAttack()
		mc=g1:GetNext()
	end
	if Duel.SelectYesNo(tp,aux.Stringid(65060022,0)) then
		Duel.Recover(tp,dam,REASON_EFFECT)
	else
		dam=dam/2
		Duel.Damage(1-tp,dam,REASON_EFFECT,true)
		Duel.Damage(tp,dam,REASON_EFFECT,true)
		Duel.RDComplete()
	end
	Duel.BreakEffect()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		 local e1=Effect.CreateEffect(e:GetHandler())
		 e1:SetType(EFFECT_TYPE_SINGLE)
		 e1:SetCode(EFFECT_UPDATE_ATTACK)
		 e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		 e1:SetReset(RESET_EVENT+0x1fe0000)
		 e1:SetValue(500)
		 tc:RegisterEffect(e1)
	end
end