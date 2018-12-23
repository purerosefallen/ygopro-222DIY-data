local m=77709000
local cm=_G["c"..m]
xpcall(function() require("expansions/script/lap") end,function() require("expansions/sekka1217/script/lap") end)
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Sekka_name_with_lap=true
function cm.initial_effect(c)
	--for test only
	local e1=Auxiliary.AddRitualProcEqual2(c,Sekka.IsLap)
	local tg=e1:GetTarget()
	local op=e1:GetOperation()
	local function f(c,e,tp)
		return bit.band(c:GetType(),0x81)==0x81 and Sekka.IsLap(c) and Duel.CheckLPCost(tp,c:GetLevel()*500) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
	end
	e1:SetTarget(Senya.multi_choice_target(m,tg,function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsExistingMatchingCard(f,tp,LOCATION_HAND,0,1,nil,e,tp) end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	end))
	e1:SetOperation(Senya.multi_choice_operation(op,function(e,tp,eg,ep,ev,re,r,rp,chk)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=Duel.SelectMatchingCard(tp,f,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		local tc=tg:GetFirst()
		if tc then
			Duel.PayLPCost(tp,tc:GetLevel()*500)
			Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
			tc:CompleteProcedure()
		end
	end))
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,m+200)
	e3:SetCost(cm.thcost)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
	local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_DISCARD)
    e1:SetCountLimit(1,m)
    e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
        if chk==0 then return true end
    end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SEA_PULSE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetValue(1)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_MATERIAL_CHECK)
		e2:SetLabelObject(e1)
		e2:SetProperty(EFFECT_FLAG_IGNORE_RANGE)
		e2:SetTargetRange(0xff,0xff)
		e2:SetReset(RESET_PHASE+PHASE_END)
		e2:SetTarget(function(e,c)
			return bit.band(c:GetType(),0x81)==0x81
		end)
		e2:SetValue(function(e,c)
			Debug.Message(0)
			if c:GetMaterial():IsExists(function(c)
				return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsControler(1-tp)
			end,1,nil) then
				Debug.Message(1)
				e:GetLabelObject():Reset()
				e:Reset()
			end
		end)
		Duel.RegisterEffect(e2,tp)
    end)
	c:RegisterEffect(e1)
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local function f(c)
		return c:IsDiscardable() and Sekka.IsLap(c) and c:IsType(TYPE_MONSTER)
	end
	if chk==0 then return Duel.IsExistingMatchingCard(f,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,f,1,1,REASON_COST+REASON_DISCARD)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end
