local m=77702005
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetCondition(function(e)
		local tp=e:GetHandlerPlayer()
		return Duel.IsExistingMatchingCard(function(c)
				return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
			end,tp,0,LOCATION_ONFIELD,2,nil)
	end)
	c:RegisterEffect(e2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetMatchingGroup(function(c)
			return c:IsFaceup() and c:IsType(TYPE_RITUAL)
		end,tp,LOCATION_MZONE,0,nil)
		if chk==0 then return #g>0 end
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetMatchingGroup(function(c)
			return c:IsFaceup() and c:IsType(TYPE_RITUAL)
		end,tp,LOCATION_MZONE,0,nil)
		for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetDescription(m*16+1)
			e1:SetValue(1)
			e1:SetReset(0x1fe1000)
			tc:RegisterEffect(e1)
		end
	end)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(function(c)
		return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
	end,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(function(c)
		return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
	end,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
	local og=Duel.GetOperatedGroup()
	if og then
		local count=0
		for p=0,1 do
			local ct=og:FilterCount(function(c)
				return c:IsLocation(LOCATION_DECK) and c:IsControler(p)
			end,nil)
			count=count|(ct<<(p*8))
		end
		local allow=true
		if (count>>(tp*8))&0xff>0 then
			Duel.ShuffleDeck(tp)
			allow=false
		end
		if (count>>((1-tp)*8))&0xff>0 then
			Duel.ShuffleDeck(1-tp)
		end
		if allow then
			local tg=Duel.GetMatchingGroup(function(c)
				return c:IsAbleToHand() and c:IsLevelAbove(7) and c:IsType(TYPE_RITUAL)
			end,tp,LOCATION_DECK,0,nil)
			if #tg>0 and Duel.SelectYesNo(tp,m*16) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg=tg:Select(tp,1,1,nil)
				Duel.BreakEffect()
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
			end
		end
	end
end
