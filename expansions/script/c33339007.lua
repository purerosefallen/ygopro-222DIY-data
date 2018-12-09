local m=33339007
local cm=_G["c"..m]
cm.name="星锁少女 源星雨"
--效 果 参 数 设 定
cm.effect_atk=500   --攻 击 力 下 降 的 数 值
cm.effect_chain=3   --连 锁 N以 后 才 能 发 动

cm.flag_atk=33339002	--攻 击 力 下 降 变 成 攻 击 力 上 升
cm.flag_chain=33339001  --连 锁 数 减 少 1

cm.isStarLock=true  --内 置 字 段
cm.set_card=0x55f   --字 段
function cm.initial_effect(c)
	--Atk Down
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(cm.atkop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--Chain N
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetCategory(CATEGORY_DISABLE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,m)
	e4:SetCondition(cm.chaincon)
	e4:SetCost(cm.chaincost)
	e4:SetTarget(cm.chaintg)
	e4:SetOperation(cm.chainop)
	c:RegisterEffect(e4)
end
function cm.isset(c)
	return c:IsSetCard(cm.set_card) or c.isStarLock
end
--Atk Down
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		if cm.flag_atk and Duel.IsPlayerAffectedByEffect(tp,cm.flag_atk) then
			e1:SetValue(cm.effect_atk)
		else
			e1:SetValue(-cm.effect_atk)
		end
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end
--Chain N
function cm.setfilter(c)
	return cm.isset(c) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function cm.chaincon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	local ct=2
	if cm.flag_chain and Duel.IsPlayerAffectedByEffect(tp,cm.flag_chain) then ct=3 end
	return Duel.GetCurrentChain()>cm.effect_chain-ct
end
function cm.chaincost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHandAsCost() end
	Duel.SendtoHand(e:GetHandler(),nil,REASON_COST)
end
function cm.chaintg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		for i=1,ev do
			if Duel.IsChainDisablable(i) then return true end
		end
		return false
	end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,0,0)
	Duel.SetChainLimit(cm.chlimit)
end
function cm.chlimit(e,ep,tp)
	return tp~=ep or cm.isset(e:GetHandler())
end
function cm.chainop(e,tp,eg,ep,ev,re,r,rp)
	local ct={}
	for i=1,ev do
		if Duel.IsChainDisablable(i) then table.insert(ct,i) end
	end
	if #ct==0 then return Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(m,3)) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
	local ac=Duel.AnnounceNumber(tp,table.unpack(ct))
	Duel.NegateActivation(ac)
	if Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(m,4)) then
		Duel.BreakEffect()
		local g=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.SSet(tp,g)
		Duel.ConfirmCards(1-tp,g)
	end
end