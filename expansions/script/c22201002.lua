--幽冥锻造术
function c22201002.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22201002+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c22201002.cost)
	e1:SetTarget(c22201002.target)
	e1:SetOperation(c22201002.activate)
	c:RegisterEffect(e1)
	if not c22201002.global_check then
		c22201002.global_check=true
		c22201002[0]=true
		c22201002[1]=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c22201002.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c22201002.clear)
		Duel.RegisterEffect(ge2,0)
	end
end
function c22201002.checkop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsType(TYPE_EQUIP) then
		c22201002[rp]=false
	end
end
function c22201002.clear(e,tp,eg,ep,ev,re,r,rp)
	c22201002[0]=true
	c22201002[1]=true
end
function c22201002.cfilter(c)
	return bit.band(c:GetReason(),REASON_DESTROY)==REASON_DESTROY and c:IsAbleToRemoveAsCost()
end
function c22201002.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c22201002.cfilter,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return c22201002[tp] and g:GetCount()>0 end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	--oath effects
	local e0=Effect.CreateEffect(e:GetHandler())
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e0:SetCode(EFFECT_CANNOT_ACTIVATE)
	e0:SetTargetRange(1,0)
	e0:SetValue(c22201002.aclimit)
	e0:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e0,tp)
end
function c22201002.aclimit(e,re,tp)
	return re:GetHandler():IsType(TYPE_EQUIP)
end
function c22201002.tgfilter(c,tp)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(c22201002.eqfilter,tp,LOCATION_DECK,0,1,nil,tp,c)
end
function c22201002.eqfilter(c,tp,ec)
	return c:CheckUniqueOnField(tp) and c:CheckEquipTarget(ec)
end
function c22201002.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c22201002.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c22201002.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,0,0,0)
end
function c22201002.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local ct=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local g=Duel.GetMatchingGroup(c22201002.eqfilter,tp,LOCATION_DECK,0,nil,tp,tc)
	if not (ct>0 and g:GetCount()>0 and tc:IsRelateToEffect(e) and tc:IsFaceup()) then return end
	if ct>2 then ct=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local eg=g:Select(tp,1,1,nil)
	g:Remove(Card.IsCode,nil,eg:GetFirst():GetCode())
	while g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(22201002,0)) and ct==2 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		egx=g:Select(tp,1,1,nil)
		eg:Merge(egx)
		break
	end
	local ec=eg:GetFirst()
	while ec do
		Duel.Equip(tp,ec,tc,true,true)
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e0:SetReset(RESET_EVENT+0xfe0000)
		e0:SetCondition(c22201002.con)
		e0:SetValue(LOCATION_REMOVED)
		ec:RegisterEffect(e0)
		ec=eg:GetNext()
	end
	Duel.EquipComplete()
end
function c22201002.con(e)
	return e:GetHandler():GetType()==TYPE_EQUIP+TYPE_SPELL 
end