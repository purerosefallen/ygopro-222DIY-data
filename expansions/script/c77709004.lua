local m=77709004
local cm=_G["c"..m]
xpcall(function() require("expansions/script/lap") end,function() require("expansions/sekka1217/script/lap") end)
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Sekka_name_with_lap=true
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_TOGRAVE)
	e1:SetCountLimit(1,m)
	e1:SetCost(Senya.SelfToHandCost)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return true end
		local g=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
		Duel.ConfirmCards(tp,g)
		local tg=g:Filter(function(c)
			local lv=c:GetLevel()
			return c:IsType(TYPE_MONSTER) and lv>0 and lv<=9
		end,nil)
		if tg:CheckWithSumEqual(Card.GetLevel,9,1,#tg) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg=tg:SelectWithSumEqual(tp,Card.GetLevel,9,1,#tg)
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end
	end)
	c:RegisterEffect(e1)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_DISCARD)
    --e1:SetProperty(0x14000)
    --e1:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
    e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
        if chk==0 then return true end
    end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local function f(c)
			local te=c:GetActivateEffect()
			local b1=c:IsSSetable()
			local b2=e:IsActivatable(tp)
			return c:IsCode(m-4) and (b1 or b2)
		end
        	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
		local g=Duel.SelectMatchingCard(tp,f,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp)
		local tc=g:GetFirst()
		if tc then
			local b1=tc:IsSSetable()
			local b2=tc:GetActivateEffect():IsActivatable(tp)
			if b1 and (not b2 or Duel.SelectOption(tp,1153,1150)==0) then
				Duel.SSet(tp,tc)
				Duel.ConfirmCards(1-tp,tc)
			else
				Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
				local te=tc:GetActivateEffect()
				te:UseCountLimit(tp,1,true)
				local cost=te:GetCost()
				if cost then cost(te,tp,eg,ep,ev,re,r,rp,1) end
				local target=te:GetTarget()
				if target then target(te,tp,eg,ep,ev,re,r,rp,1) end
				local operation=te:GetOperation()
				if operation then operation(te,tp,eg,ep,ev,re,r,rp) end
				Duel.SendtoGrave(tc,REASON_EFFECT)
			end
		end
    end)
    c:RegisterEffect(e1)
end
