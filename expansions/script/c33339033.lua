local m=33339033
local cm=_G["c"..m]
cm.name="星锁奇门"
--效 果 参 数 设 定
cm.effect_chain=4   --连 锁 N以 后 才 能 发 动
cm.effect_deck=2	--盲 堆 数 量
cm.effect_atk=200   --每 张 卡 增 加 的 攻 击 力

cm.isStarLock=true  --内 置 字 段
cm.set_card=0x55f   --字 段
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.condition)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
	--Chain N
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_DECKDES)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCondition(cm.chaincon)
	e4:SetTarget(cm.chaintg)
	e4:SetOperation(cm.chainop)
	c:RegisterEffect(e4)
end
function cm.isset(c)
	return c:IsSetCard(cm.set_card) or c.isStarLock
end
--Search
function cm.filter(c)
	return cm.isset(c) and c:IsAbleToHand()
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainDisablable(ev) and cm.isset(re:GetHandler())
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetChainLimit(cm.chlimit)
end
function cm.chlimit(e,ep,tp)
	return tp~=ep or cm.isset(e:GetHandler())
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.NegateEffect(ev) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
--Chain N
function cm.upfilter(c)
	return c:IsFaceup() and cm.isset(c)
end
function cm.chaincon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	local ct=2
	if cm.flag_chain and Duel.IsPlayerAffectedByEffect(tp,cm.flag_chain) then ct=3 end
	return Duel.GetCurrentChain()>cm.effect_chain-ct
end
function cm.chaintg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) and e:GetHandler():GetFlagEffect(m)==0 end
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,1)
	Duel.SetChainLimit(cm.chlimit)
end
function cm.chainop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local dis={}
	for i=cm.effect_deck,1,-1 do
		if Duel.IsPlayerCanDiscardDeck(tp,i) then
			table.insert(dis,i)
		end
	end
	if #dis==0 then return end
	local disct=dis[1]
	if #dis>1 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
		local disct=Duel.AnnounceNumber(tp,table.unpack(dis))
	end
	local ct=Duel.DiscardDeck(tp,disct,REASON_EFFECT)
	if Duel.IsExistingMatchingCard(cm.upfilter,tp,LOCATION_MZONE,0,1,nil) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectMatchingCard(tp,cm.upfilter,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.HintSelection(g)
		local tc=g:GetFirst()
		if tc then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(ct*cm.effect_atk)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			tc:RegisterEffect(e2)
		end
	end
end