--异界恶魔蝠 阿比
function c13255224.initial_effect(c)
	c:EnableUnsummonable()
	--spsummon condition
	--local e0=Effect.CreateEffect(c)
	--e0:SetType(EFFECT_TYPE_SINGLE)
	--e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	--e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	--e0:SetValue(c13255224.splimit)
	--c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c13255224.spcon)
	e1:SetOperation(c13255224.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13255224,2))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCost(c13255224.cost)
	e2:SetOperation(c13255224.operation)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(13255224,0))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c13255224.discon)
	e3:SetTarget(c13255224.distg)
	e3:SetOperation(c13255224.disop)
	c:RegisterEffect(e3)
	--destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c13255224.repval)
	e4:SetTarget(c13255224.reptg)
	e4:SetOperation(c13255224.repop)
	c:RegisterEffect(e4)
	
end
function c13255224.splimit(e,se,sp,st)
	return se:GetHandler()==e:GetHandler()
end
function c13255224.spfilter(c)
	return c:IsCode(13255222) and c:IsAbleToDeckAsCost()
end
function c13255224.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c13255224.spfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,nil)
end
function c13255224.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c13255224.spfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c13255224.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return Duel.IsChainNegatable(ev) and ep~=tp and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==1
end
function c13255224.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c13255224.disop(e,tp,eg,ep,ev,re,r,rp)
	local cc=Duel.GetChainInfo(0,CHAININFO_CHAIN_COUNT)-1
	local g=Group.CreateGroup()
	for i=1,cc do
		local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		if te:GetOwnerPlayer()~=tp and Duel.NegateActivation(i) and te:GetHandler():IsRelateToEffect(re) then
			g:AddCard(te:GetHandler())
		end
	end
	if g:GetCount()>0
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
	--if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
	--	Duel.SendtoDeck(eg,nil,2,REASON_EFFECT)
	--end
end
function c13255224.repval(e,c)
	return c:IsLocation(LOCATION_ONFIELD)
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c13255224.repfilter(c)
	return c:IsLevelBelow(1)
end
function c13255224.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsOnField() and c:IsFaceup()
		and Duel.IsExistingMatchingCard(c13255224.repfilter,tp,LOCATION_HAND,0,1,nil) end
	if Duel.SelectYesNo(tp,aux.Stringid(13255224,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,c13255224.repfilter,tp,LOCATION_HAND,0,1,1,nil)
		e:SetLabelObject(g:GetFirst())
		return true
	else return false end
end
function c13255224.repop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoGrave(tc,REASON_EFFECT)
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
	--if tc:IsCode(13255219) then
	--  local dg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	--  if dg:GetCount()>0 then
	--	  Duel.Destroy(dg,REASON_EFFECT)
	--  end
	--end
end

function c13255224.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c13255224.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c13255224.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c13255224.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA)
end

