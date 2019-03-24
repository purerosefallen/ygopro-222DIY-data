--白雪安娜
function c81011003.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2)
	c:EnableReviveLimit()
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c81011003.efilter)
	c:RegisterEffect(e1)
	--change battle target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,81011003)
	e2:SetCondition(c81011003.cbcon)
	e2:SetTarget(c81011003.cbtg)
	e2:SetOperation(c81011003.cbop)
	c:RegisterEffect(e2)
	--change effect target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,81011003)
	e3:SetCondition(c81011003.cecon)
	e3:SetTarget(c81011003.cetg)
	e3:SetOperation(c81011003.ceop)
	c:RegisterEffect(e3)
end
function c81011003.efilter(e,re,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g:IsContains(e:GetHandler())
end
function c81011003.tgtg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end
function c81011003.cbcon(e,tp,eg,ep,ev,re,r,rp)
	return r~=REASON_REPLACE
end
function c81011003.cbfilter(c,at)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and at:IsContains(c)
end
function c81011003.cbtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local at=Duel.GetAttacker():GetAttackableTarget()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c81011003.cbfilter(chkc,at) end
	if chk==0 then return Duel.IsExistingTarget(c81011003.cbfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler(),at) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c81011003.cbfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler(),at)
end
function c81011003.cbop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not Duel.GetAttacker():IsImmuneToEffect(e) then
		Duel.ChangeAttackTarget(tc)
	end
end
function c81011003.cecon(e,tp,eg,ep,ev,re,r,rp)
	if e==re or rp==tp or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:GetCount()==1 and g:GetFirst()==e:GetHandler()
end
function c81011003.cefilter(c,re,rp,tf,ceg,cep,cev,cre,cr,crp)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and tf(re,rp,ceg,cep,cev,cre,cr,crp,0,c)
end
function c81011003.cetg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tf=re:GetTarget()
	local res,ceg,cep,cev,cre,cr,crp=Duel.CheckEvent(re:GetCode(),true)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c81011003.cefilter(chkc,re,rp,tf,ceg,cep,cev,cre,cr,crp) end
	if chk==0 then return Duel.IsExistingTarget(c81011003.cefilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler(),re,rp,tf,ceg,cep,cev,cre,cr,crp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c81011003.cefilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler(),re,rp,tf,ceg,cep,cev,cre,cr,crp)
end
function c81011003.ceop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.ChangeTargetCard(ev,Group.FromCards(tc))
	end
end
