local m=33339031
local cm=_G["c"..m]
cm.name="星锁八极 破"
--效 果 参 数 设 定
cm.effect_chain=4   --连 锁 N以 后 才 能 发 动

cm.flag_chain=33339001  --连 锁 数 减 少 1

cm.isStarLock=true  --内 置 字 段
cm.set_card=0x55f   --字 段
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--Chain N
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,m)
	e4:SetCondition(cm.chaincon)
	e4:SetTarget(cm.chaintg)
	e4:SetOperation(cm.chainop)
	c:RegisterEffect(e4)
end
function cm.isset(c)
	return c:IsSetCard(cm.set_card) or c.isStarLock
end
--Activate
function cm.filter(c)
	return cm.isset(c) and c:IsType(TYPE_MONSTER) and c:IsSummonable(true,nil)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local chain=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT)
	return Duel.GetCurrentChain()>1 and cm.isset(chain:GetHandler()) and Duel.IsChainDisablable(ev)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ph=Duel.GetCurrentPhase()
	if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_BATTLE_PHASE)==0 end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND,0,1,1,nil)
		local tc=g:GetFirst()
		Duel.Summon(tp,tc,true,nil)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
--Chain N
function cm.thfilter(c)
	return cm.isset(c) and c:IsAbleToHand()
end
function cm.chaincon(e,tp,eg,ep,ev,re,r,rp)
	local ct=2
	if cm.flag_chain and Duel.IsPlayerAffectedByEffect(tp,cm.flag_chain) then ct=3 end
	return Duel.GetCurrentChain()>cm.effect_chain-ct
end
function cm.chaintg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
	Duel.SetChainLimit(cm.chlimit)
end
function cm.chlimit(e,ep,tp)
	return tp~=ep or cm.isset(e:GetHandler())
end
function cm.chainop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,g)
		Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
	end
end