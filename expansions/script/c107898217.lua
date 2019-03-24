--STSR·异蛇之眼
function c107898217.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c107898217.target)
	e1:SetOperation(c107898217.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_EQUIP_LIMIT)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetValue(c107898217.eqlimit)
	c:RegisterEffect(e0)
	--look when draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(107898217,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_DRAW)
	e2:SetCategory(CATEGORY_DICE+CATEGORY_LVCHANGE)
	e2:SetCondition(c107898217.cfcon)
	e2:SetOperation(c107898217.cfop)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(107898313)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(0x10000000+107898313)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,0)
	c:RegisterEffect(e4)
end
function c107898217.eqfilter1(c)
	return c:IsFaceup() and c:IsCode(107898101,107898102,107898103)
end
function c107898217.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c107898217.eqfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c107898217.eqfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c107898217.eqfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c107898217.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() and c:CheckUniqueOnField(tp) then
		Duel.Equip(tp,c,tc)
	end
end
function c107898217.eqlimit(e,c)
	return c:IsCode(107898101,107898102,107898103)
end
function c107898217.cfcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c107898217.filter(c)
	return c:IsLocation(LOCATION_HAND) and not c:IsPublic()
end
function c107898217.clfilter(c,tp)
	return (c:IsSetCard(0x575a) or c:IsSetCard(0x575c)
		or (c:IsSetCard(0x575b) and Duel.IsPlayerAffectedByEffect(tp,107898504)==nil)) and c:IsType(TYPE_MONSTER)
end
function c107898217.cfop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local cg=eg:Filter(c107898217.filter,nil)
	Duel.ConfirmCards(1-tp,cg)
	local lcg=cg:Filter(c107898217.clfilter,nil,tp)
	if lcg:GetCount()<=0 then return end
	local lc=lcg:GetFirst()
	while lc~=nil do
		local g=Group.CreateGroup()
		g:AddCard(lc)
		Duel.HintSelection(g)
		local lv=Duel.TossDice(tp,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		lc:RegisterEffect(e1)
		lc=lcg:GetNext()
	end
	Duel.ShuffleHand(tp)
end