--极死·七夜
function c22262102.initial_effect(c)
	--ACTIVATE
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c22262102.condition)
	e1:SetTarget(c22262102.target)
	e1:SetOperation(c22262102.activate)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetTarget(c22262102.tg)
	e2:SetOperation(c22262102.op)
	c:RegisterEffect(e2)
end
c22262102.named_with_NanayaShiki=1
c22262102.Desc_Contain_NanayaShiki=1
function c22262102.IsNanayaShiki(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_NanayaShiki
end
function c22262102.actfilter(c)
	return c:IsFaceup() and c22262102.IsNanayaShiki(c)
end
function c22262102.actcon(e)
	return Duel.IsExistingMatchingCard(c22262102.actfilter,e:GetHandler():GetControler(),LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c22262102.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>0
end
function c22262102.filter(c)
	return c:IsFaceup() and c22262102.IsNanayaShiki(c)
end
function c22262102.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c22262102.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22262102.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local op=Duel.SelectOption(tp,aux.Stringid(22262102,0),aux.Stringid(22262102,1))
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_DESTROY)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local tc=Duel.SelectTarget(tp,c22262102.filter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
		local dg=tc:GetColumnGroup()
		dg:AddCard(tc)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,dg:GetCount(),0,LOCATION_ONFIELD)
	else
		e:SetCategory(CATEGORY_DAMAGE)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_PLAYER_TARGET)
		local tc=Duel.SelectTarget(tp,c22262102.filter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
		Duel.SetTargetPlayer(1-tp)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,tc:GetAttack())
	end
end
function c22262102.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if e:GetLabel()==0 then
		local dg=tc:GetColumnGroup()
		dg:AddCard(tc)
		Duel.Destroy(dg,REASON_EFFECT)
	else
		local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
		Duel.Damage(p,tc:GetAttack(),REASON_EFFECT)
	end
end
function c22262102.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1200)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1200)
end
function c22262102.op(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end