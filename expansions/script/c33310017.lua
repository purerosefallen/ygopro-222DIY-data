--泰拉勇者 魔法师
if not pcall(function() require("expansions/script/c33310023") end) then require("script/c33310023") end
local m=33310017
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate or Set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--des
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.destg)
	e2:SetOperation(cm.desop)
	c:RegisterEffect(e2)	
end
cm.setcard="terraria"
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.desfilter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(cm.thfilter,tp,0,LOCATION_ONFIELD,1,nil) and Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerCanDraw(1-tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,1-tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
	Duel.SetChainLimit(cm.chlimit)
end
function cm.chlimit(e,ep,tp)
	return tp==ep
end
function cm.desfilter(c)
	return c.setcard=="terraria" and c:IsFaceup()
end
function cm.thfilter(c)
	return c:IsFacedown() and c:IsAbleToHand()
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,cm.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	if g:GetCount()>0 then
	   Duel.HintSelection(g)
	   if Duel.Destroy(g,REASON_EFFECT)~=0 then
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		  local tg=Duel.SelectMatchingCard(tp,cm.thfilter,tp,0,LOCATION_ONFIELD,1,1,nil)	  
		  if tg:GetCount()>0 and Duel.SendtoHand(tg,nil,REASON_EFFECT)~=0 then
			 Duel.BreakEffect()
			 Duel.Draw(tp,1,REASON_EFFECT)
			 Duel.Draw(1-tp,1,REASON_EFFECT)
		  end   
	   end
	end
end
function cm.sfilter(c,tp)
	if c.setcard~="terraria" then return false end
	return (c:IsType(TYPE_FIELD+TYPE_CONTINUOUS) and c:GetActivateEffect():IsActivatable(tp) and c:IsType(TYPE_SPELL)) or (c:IsType(TYPE_TRAP) and c:IsSSetable())
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.sfilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local tc=Duel.SelectMatchingCard(tp,cm.sfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then
		if tc:IsType(TYPE_FIELD) then
		   local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		   if fc then
			  Duel.SendtoGrave(fc,REASON_RULE)
			  Duel.BreakEffect()
		   end
		end
		if tc:IsType(TYPE_SPELL) then
		   Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		   local te=tc:GetActivateEffect()
		   local tep=tc:GetControler()
		   local cost=te:GetCost()
		   if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end 
		   if tc:IsType(TYPE_FIELD) then
			  Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
		   end
		else
		   Duel.SSet(tp,tc)
		end
		Duel.BreakEffect()
		Duel.Draw(1-tp,1,REASON_EFFECT)
	end
end
