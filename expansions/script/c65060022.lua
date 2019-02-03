--梦之德莱姆
function c65060022.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
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
function c65060022.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x6da4) and c:GetAttack()==c:GetBaseAttack()
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

function c65060022.filtern(c)
	return c:IsFaceup() and c:IsSetCard(0x6da4) 
end
function c65060022.damtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c65060022.filtern(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c65060022.filtern,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.SelectTarget(tp,c65060022.filtern,tp,LOCATION_MZONE,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,g,1,0,0)
end

function c65060022.damop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local g1=Duel.GetMatchingGroup(c65060022.filtern,tp,LOCATION_MZONE,0,nil)
	local mc=g1:GetFirst()
	local dam=0
	while mc do
		dam=dam+mc:GetAttack()
		mc=g1:GetNext()
	end
	if Duel.SelectYesNo(tp,aux.Stringid(65060022,0)) then
		Duel.Recover(tp,dam,REASON_EFFECT)
	else
		Duel.Damage(1-tp,dam,REASON_EFFECT)
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