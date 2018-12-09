local m=33339009
local cm=_G["c"..m]
cm.name="星锁迷云 星母"
--效 果 参 数 设 定
cm.effect_atk=500   --攻 击 力 下 降 的 数 值
cm.effect_chain=4   --连 锁 N才 能 发 动
cm.effect_draw=1	--对 方 抽 卡 数
cm.effect_deck=2	--盲 堆 数 量

cm.flag_atk=33339002	--攻 击 力 下 降 变 成 攻 击 力 上 升
cm.flag_chain=33339001  --连 锁 数 减 少 1

cm.isStarLock=true  --内 置 字 段
cm.set_card=0xe5f   --字 段
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
	--Draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCondition(cm.condition)
	e3:SetCost(cm.cost)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
	--Chain N
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DISABLE+CATEGORY_DECKDES)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,m)
	e4:SetCondition(cm.chaincon)
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
--Draw
function cm.filter(c)
	return cm.isset(c) and c:IsAbleToGraveAsCost()
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT) and cm.isset(re:GetHandler())
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(1-tp,cm.effect_draw) end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(cm.effect_draw)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,cm.effect_draw)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
--Chain N
function cm.chainfilter(c)
	return c:IsFaceup() and cm.isset(c) and c:IsAbleToGrave()
end
function cm.chaincon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	local ct=1
	if cm.flag_chain and Duel.IsPlayerAffectedByEffect(tp,cm.flag_chain) then ct=2 end
	return Duel.GetCurrentChain()==cm.effect_chain-ct
end
function cm.chaintg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.chainfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_ONFIELD)
	Duel.SetChainLimit(cm.chlimit)
end
function cm.chlimit(e,ep,tp)
	return tp~=ep or cm.isset(e:GetHandler())
end
function cm.chainop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.chainfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	if g:GetCount()==0 then return end
	Duel.SendtoGrave(g,REASON_COST)
	local ct={}
	for i=1,ev do
		if Duel.IsChainDisablable(i) then table.insert(ct,i) end
	end
	if #ct>0 and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,4))
		local ac=Duel.AnnounceNumber(tp,table.unpack(ct))
		Duel.NegateEffect(ac)
	end
	if Duel.IsPlayerCanDiscardDeck(tp,1)
		and Duel.SelectYesNo(tp,aux.Stringid(m,5)) then
		Duel.BreakEffect()
		local dis={}
		for i=cm.effect_deck,1,-1 do
			if Duel.IsPlayerCanDiscardDeck(tp,i) then
				table.insert(dis,i)
			end
		end
		if #dis==1 then 
			Duel.DiscardDeck(tp,dis[1],REASON_EFFECT)
		else
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,6))
			local disct=Duel.AnnounceNumber(tp,table.unpack(dis))
			Duel.DiscardDeck(tp,disct,REASON_EFFECT)
		end
	end
end