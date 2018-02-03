--最强的炎精灵-斯卡雷特
local m=5200027
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddXyzProcedure(c,nil,3,3,function(c) return c:IsCode(5200008) end,m*16)
	c:EnableReviveLimit()
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	end)
	e2:SetCondition(function(e,tp)
		local ph=Duel.GetCurrentPhase()
		return Duel.GetTurnPlayer()==tp and ph>=PHASE_MAIN1 and ph<=PHASE_MAIN2
	end)
	e2:SetTarget(cm.tdtg)
	e2:SetOperation(cm.tdop)
	c:RegisterEffect(e2)
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	local tc=g:GetFirst()
	if not tc then return end
	Duel.HintSelection(g)
	if Duel.SendtoGrave(tc,POS_FACEUP,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_GRAVE) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_NECRO_VALLEY)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(0x1fe1000)
		tc:RegisterEffect(e1,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVING)
		e1:SetRange(LOCATION_GRAVE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(0x1fe1000)
		e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
			if not Duel.IsChainDisablable(ev) then return false end
			for _,ctg in ipairs({CATEGORY_SPECIAL_SUMMON,CATEGORY_REMOVE,CATEGORY_TOHAND,CATEGORY_TODECK,CATEGORY_LEAVE_GRAVE}) do
				local ex,tg,ct,p,v=Duel.GetOperationInfo(ev,ctg)
				if ex and tg and tg:IsContains(e:GetHandler()) then return true end
			end
			return false
		end)
		e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			Duel.NegateEffect(ev)
		end)
		tc:RegisterEffect(e1,true)
	end
end