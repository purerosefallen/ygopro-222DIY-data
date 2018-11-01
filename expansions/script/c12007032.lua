local m=12007032
local cm=_G["c"..m]
--黄金的女儿 学习会
function cm.initial_effect(c)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,m)
	e4:SetTarget(cm.thtg)
	e4:SetOperation(cm.thop)
	c:RegisterEffect(e4)
	--to deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_CONFIRM)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	--Destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetTarget(cm.desreptg)
	e2:SetOperation(cm.desrepop)
	c:RegisterEffect(e2)
end
function cm.filter2(c,ec)
	return c:IsSetCard(0xfb2)
end
function cm.thfilter(c)
	return c:IsSetCard(0xfb2) and c:IsType(TYPE_MONSTER)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil,e:GetHandler()) and Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,0,tp,LOCATION_SZONE)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil,e:GetHandler()) and Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_SZONE,LOCATION_SZONE,1,99,nil,e:GetHandler())
	local ct=Duel.Destroy(g,REASON_EFFECT)
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local sg=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,ct,nil)
	tc=sg:GetFirst()
	while tc do
		if Duel.Equip(tp,tc,c,true)~=0 then 
			local e1=Effect.CreateEffect(c)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(cm.eqlimit)
			e1:SetLabelObject(c)
			tc:RegisterEffect(e1)
			Duel.EquipComplete()
		end
		tc=sg:GetNext()
	end
end
function cm.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function cm.filter4(c,ec)
	return c:GetEquipTarget()==ec and c:IsAbleToGraveAsCost()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter4,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.filter4,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local t=Duel.GetAttackTarget()
	if chk ==0 then return Duel.GetAttacker()==e:GetHandler() and t~=nil and t:IsAbleToDeck() and e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,Group.FromCards(t,e:GetHandler()),2,0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local t=Duel.GetAttackTarget()
	if t~=nil and t:IsRelateToBattle() then
		local sg = Group.FromCards(t,e:GetHandler())
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	end
end 
function cm.repfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsLocation(LOCATION_SZONE) and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end
function cm.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local g=c:GetEquipGroup()
		return not c:IsReason(REASON_REPLACE) and g:IsExists(cm.repfilter,1,nil)
	end
	if Duel.SelectEffectYesNo(tp,c,96) then
		local g=c:GetEquipGroup()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:FilterSelect(tp,cm.repfilter,1,1,nil)
		Duel.SetTargetCard(sg)
		return true
	else return false end
end
function cm.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	Duel.Destroy(tg,REASON_EFFECT+REASON_REPLACE)
end