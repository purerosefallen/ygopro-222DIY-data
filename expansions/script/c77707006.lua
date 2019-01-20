local m=77707006
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
	local function f1(c)
		return c:IsType(TYPE_SPELL) and c:IsType(TYPE_RITUAL) and c:IsAbleToHand()
	end
	local function f2(c)
		return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL) and c:IsAbleToHand()
	end
	local function add_count_check(e,tp)
		local c=e:GetHandler()
		if Duel.GetTurnPlayer()==tp and (c:IsLocation(LOCATION_HAND) or c:IsStatus(STATUS_ACT_FROM_HAND)) then return 1 else return 0 end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetTarget(Senya.multi_choice_target(m,
		function(e,tp,eg,ep,ev,re,r,rp,chk)
			local count=1
			local cost_target=Senya.DiscardHandCost(count+add_count_check(e,tp))
			if chk==0 then return Duel.IsExistingMatchingCard(f1,tp,LOCATION_DECK,0,count,nil) and cost_target(e,tp,eg,ep,ev,re,r,rp,chk) end
			cost_target(e,tp,eg,ep,ev,re,r,rp,chk)
			e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
			Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,count,tp,LOCATION_DECK)
		end,
		function(e,tp,eg,ep,ev,re,r,rp,chk)
			local count=2
			local cost_target=Senya.DiscardHandCost(count+add_count_check(e,tp))
			if chk==0 then return Duel.IsExistingMatchingCard(f1,tp,LOCATION_DECK,0,count,nil) and cost_target(e,tp,eg,ep,ev,re,r,rp,chk) end
			cost_target(e,tp,eg,ep,ev,re,r,rp,chk)
			e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
			Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,count,tp,LOCATION_DECK)
		end,
		function(e,tp,eg,ep,ev,re,r,rp,chk)
			local count=3
			local cost_target=Senya.DiscardHandCost(count+add_count_check(e,tp))
			local hand_count={}
			for p=0,1 do
				hand_count[p]=Duel.GetFieldGroupCount(p,LOCATION_HAND,0)
			end
			if chk==0 then return hand_count[tp]-3-add_count_check(e,tp)<hand_count[1-tp] and Duel.IsPlayerCanDraw(tp,hand_count[1-tp]-hand_count[tp]+3) and cost_target(e,tp,eg,ep,ev,re,r,rp,chk) end
			cost_target(e,tp,eg,ep,ev,re,r,rp,chk)
			e:SetCategory(CATEGORY_DRAW)
			Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,hand_count[1-tp]-hand_count[tp],0,0)
		end
	))
	e1:SetOperation(Senya.multi_choice_operation(
		function(e,tp,eg,ep,ev,re,r,rp)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,f1,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end,
		function(e,tp,eg,ep,ev,re,r,rp)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,f2,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end,
		function(e,tp,eg,ep,ev,re,r,rp)
			local hand_count={}
			for p=0,1 do
				hand_count[p]=Duel.GetFieldGroupCount(p,LOCATION_HAND,0)
			end
			local diff=hand_count[1-tp]-hand_count[tp]
			if diff>0 then
				Duel.Draw(tp,diff,REASON_EFFECT)
			end
		end
	))
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,m)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
end
function cm.thfilter(c)
	return c:IsAbleToHand() and c:IsCode(m+1)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
