local m=33339011
local cm=_G["c"..m]
cm.name="星锁之环 跃迁之门"
--效 果 参 数 设 定
cm.effect_atk=500   --攻 击 力 下 降 的 数 值
cm.effect_chain=4   --连 锁 N以 后 才 能 发 动
cm.effect_deck=2	--盲 堆 数 量

cm.flag_atk=33339002	--攻 击 力 下 降 变 成 攻 击 力 上 升
cm.flag_chain=33339001  --连 锁 数 减 少 1

cm.isStarLock=true  --内 置 字 段
cm.set_card=0x55f   --字 段
function cm.initial_effect(c)
	--Atk Down
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(cm.atkop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--Special Summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(cm.condition)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
	--Chain N
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetCategory(CATEGORY_DISABLE+CATEGORY_DECKDES)
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
--Special Summon
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return cm.isset(re:GetHandler()) and not e:GetHandler():IsStatus(STATUS_CHAINING)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		if Duel.IsChainNegatable(ev) and Duel.SelectYesNo(tp,aux.Stringid(m,4)) then
			Duel.BreakEffect()
			Duel.NegateActivation(ev)
		end
	end
end
--Chain N
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
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) end
	local ng=Group.CreateGroup()
	for i=1,ev do
		local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		local tc=te:GetHandler()
		if tc:IsControler(1-tp) then ng:AddCard(tc) end
	end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,ng,ng:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,1)
	Duel.SetChainLimit(cm.chlimit)
end
function cm.chlimit(e,ep,tp)
	return tp~=ep or cm.isset(e:GetHandler())
end
function cm.chainop(e,tp,eg,ep,ev,re,r,rp)
	for i=1,ev do
		local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		if te:GetHandlerPlayer()==1-tp then
			Duel.NegateEffect(i)
		end
	end
	local dis={}
	for i=cm.effect_deck,1,-1 do
		if Duel.IsPlayerCanDiscardDeck(tp,i) then
			table.insert(dis,i)
		end
	end
	if #dis==0 then return end
	if #dis==1 then 
		Duel.DiscardDeck(tp,dis[1],REASON_EFFECT)
	else
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,3))
		local disct=Duel.AnnounceNumber(tp,table.unpack(dis))
		Duel.DiscardDeck(tp,disct,REASON_EFFECT)
	end
end