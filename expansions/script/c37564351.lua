local m=37564351
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	Auxiliary.AddLinkProcedure(c,function(tc)
		local tp=c:GetControler()
		local list=cm[1-tp]
		return #list>0 and tc:IsCode(table.unpack(list))
	end,2,2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(0x14000)
	e1:SetCountLimit(1,m)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetCondition(Senya.SummonTypeCondition(SUMMON_TYPE_LINK))
	e1:SetTarget(cm.target1)
	e1:SetOperation(cm.operation1)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(0x14000)
	e1:SetCountLimit(1,m-4000)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		return not c:IsPreviousSetCard(0x771) and c:GetPreviousControler()==tp and (c:IsReason(REASON_BATTLE) or c:GetReasonPlayer()==1-tp)
	end)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	if not cm.global_check then
		cm.global_check=true
		for p=0,1 do cm[p]={} end
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			for tc in aux.Next(eg) do
				local p=tc:GetSummonPlayer()
				local code=tc:GetOriginalCodeRule()
				table.insert( cm[p], code )
			end
		end)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	cm.announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE}
	local ac=Duel.AnnounceCardFilter(tp,table.unpack(cm.announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD_FILTER)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_EXTRA)
end
function cm.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	if #g<=0 then return end
	Duel.ConfirmCards(tp,g)
	local hit=g:Filter(function(c)
		return c:IsCode(ac) and c:IsAbleToRemove()
	end,nil)
	if #hit>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tc=hit:Select(tp,1,1,nil):GetFirst()
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetReset(0x1fe1000)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(ac)
		c:RegisterEffect(e1)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_ADD_SETCODE)
		e3:SetValue(0x771) --Used EFFECT_ADD_SETCODE for checking the previous status
		e3:SetReset(0x1fe1000)
		c:RegisterEffect(e3)
		c:CopyEffect(ac,0x1fe1000,1)
	end
end
function cm.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCode(37564331) and Duel.GetLocationCountFromEx(tp)>0
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end
