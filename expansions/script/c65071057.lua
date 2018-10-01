--猩红创痕
function c65071057.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c65071057.eqtg)
	e1:SetOperation(c65071057.eqop)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetCondition(c65071057.bzcon)
	e3:SetValue(500)
	c:RegisterEffect(e3)
	--actlimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(0,1)
	e4:SetValue(c65071057.aclimit)
	e4:SetCondition(c65071057.actcon)
	c:RegisterEffect(e4)
	--Double Attack
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetCode(EFFECT_EXTRA_ATTACK)
	e5:SetCondition(c65071057.bzcon)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	--must attack
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_EQUIP)
	e6:SetCode(EFFECT_MUST_ATTACK)
	e6:SetCondition(c65071057.mucon)
	c:RegisterEffect(e6)
end

function c65071057.bzcon(e)
	local tp=e:GetHandler():GetControler()
	local lp1=Duel.GetLP(tp)
	local lp2=Duel.GetLP(1-tp)
	return lp1<=(lp2/2)
end

function c65071057.mufil(c,e)
	return c:GetEquipCount()~=0
end

function c65071057.mucon(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.IsExistingMatchingCard(c65071057.mufil,tp,0,LOCATION_MZONE,1,nil,e)
end

function c65071057.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c65071057.actcon(e)
	return Duel.GetAttacker()==e:GetHandler():GetEquipTarget()
end
function c65071057.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c65071057.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end