--景愿『遗暗铭光』
local m=1111090
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
cm.named_with_Scenersh=true
--
function c1111090.initial_effect(c)
--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCode(EVENT_ADJUST)
	e0:SetRange(LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_GRAVE)
	e0:SetOperation(c1111090.op0)
	c:RegisterEffect(e0)
--
end
--
function c1111090.op0(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsCode(1111050) then
		local tcode=1111050
		c:SetEntityCode(tcode,true)
		c:ReplaceEffect(tcode,0,0)
		Duel.Readjust()
	end
end
--
